USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspDropSnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspDropSnapShot
	@pTableName varchar(100) = NULL
	,@pTestConfigID varchar(100) = NULL
	,@pMaxTableDaysOld int = NULL
	,@pMaxSchemaSizeMB int = NULL

AS
BEGIN
	-- if no params then drop all derived snap shots (RecordMatch, KeyMatch, PreEtlKeyMisMatch, PostEtlKeyMisMatch) do not drop PreEtlSnapShot or PostEtlSnapShot tables
	-- if @pTableName is not null then drop it and continue execution
	-- if @pTestConfigID is not null then drop all tables associated with that ConfigID and continue execution
	-- @pMaxTableDaysOld is not null or @pMaxSchemaSizeMB is not null then drop all derived tables then incrementally drop the oldest sets PreEtlSnapShot/PostEtlSnapShot tables by ConfigID until schema the schema satasfies the constraints

	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	RAISERROR('uspDropSnapShot', 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE 
		@DatabaseName varchar(100) = 'AutoTest'
		,@SchemaName varchar(100) = 'SnapShot'
		,@TableName varchar(100) = @pTableName
		,@OldTableName varchar(100)
		,@MaxTableHoursOld int
		,@SchemaSize decimal(10,3)




	--SELECT COUNT(*)
	--FROM AutoTest.sys.tables AS tab
	--WHERE OBJECT_SCHEMA_NAME(tab.object_id) = @SchemaName

	
	-- drop single table
	IF @pTableName IS NOT NULL
	BEGIN
		DECLARE @FullName varchar(300) = @DatabaseName +'.'+@SchemaName +'.'+@TableName
		SET @sql = FORMATMESSAGE('DROP TABLE %s;',@FullName);
		PRINT @sql;
		EXEC(@sql);
	END
	-- drop all tables with given ConfigID
	IF @pTestConfigID IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('
		IF OBJECT_SCHEMA_NAME(OBJECT_ID(''?'')) = ''%s'' AND ''?'' LIKE ''%s''
		BEGIN 
			PRINT ''?''+'' dropped (by TestConfigID)'';
			DROP TABLE %s.?;  
		END',@SchemaName, '%'+@pTestConfigID+'%', @DatabaseName)
		--PRINT @sql
		EXEC sp_MSforeachtable @command1 = @sql
	END
	-- drop derived Snap Shots
	IF @pTableName IS NOT NULL AND @pTestConfigID IS NOT NULL AND @pMaxTableDaysOld IS NULL AND @pMaxSchemaSizeMB IS NULL
	BEGIN
		SET @sql = FORMATMESSAGE('
		IF OBJECT_SCHEMA_NAME(OBJECT_ID(''?'')) = ''%s'' AND ''?'' NOT LIKE ''%s''
		BEGIN 
			PRINT ''?''+'' dropped (derived snap shot)'';
			DROP TABLE %s.?;  
		END',@SchemaName, '%Etl_TestConfigID%', @DatabaseName)
		--PRINT @sql
		EXEC sp_MSforeachtable @command1 = @sql
	END
	-- drop oldest table
	IF @pMaxTableDaysOld IS NOT NULL OR @pMaxSchemaSizeMB IS NOT NULL 
	-- get TestConfigID of oldest Snap Shot
	BEGIN
		-- drop derived Snap Shots (recursive call)
		EXEC AutoTest.dbo.uspDropSnapShot
		-- get oldest table
		SELECT TOP 1 @MaxTableHoursOld=DATEDIFF(hour,tab.create_date, GETDATE()), @OldTableName = tab.name
		FROM AutoTest.sys.tables AS tab
		WHERE OBJECT_SCHEMA_NAME(tab.object_id) = @SchemaName
		ORDER BY DATEDIFF(hour,tab.create_date, GETDATE()) DESC
		-- get schema size in MB
		SELECT @SchemaSize=SUM(alloc.total_pages) * 8/1024.
		FROM AutoTest.sys.tables AS tab
		INNER JOIN sys.indexes idx
		ON tab.OBJECT_ID = idx.object_id
		INNER JOIN AutoTest.sys.partitions part
		ON idx.object_id = part.OBJECT_ID 
		AND idx.index_id = part.index_id
		INNER JOIN AutoTest.sys.allocation_units alloc
		ON part.partition_id = alloc.container_id
		WHERE OBJECT_SCHEMA_NAME(tab.object_id) = @SchemaName

		-- get TestConfigID of oldest table
		SET @pTestConfigID = SUBSTRING(@OldTableName, PATINDEX('%TestConfigID%', @OldTableName) + 12, 200)

		-- if schema size too big or too old then drop oldest table
		IF (ISNULL(@pMaxTableDaysOld*24,@MaxTableHoursOld) < @MaxTableHoursOld OR ISNULL(@pMaxSchemaSizeMB,@SchemaSize) < @SchemaSize) AND @pTestConfigID IS NOT NULL
		BEGIN
			EXEC AutoTest.dbo.uspDropSnapShot @pTestConfigID = @pTestConfigID, @pMaxTableDaysOld = @pMaxTableDaysOld, @pMaxSchemaSizeMB = @pMaxSchemaSizeMB
		END
	END

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDropSnapShot
	: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO

--CREAte table autotest.SnapShot.abd(x int);
--CREAte table autotest.SnapShot.abd2(x int);
--CREAte table autotest.SnapShot.abd3(x int);
--CREAte table autotest.SnapShot.abd4(x int);
--CREAte table autotest.SnapShot.abd5(x int);
--CREAte table autotest.SnapShot.abd6(x int);
--CREAte table autotest.SnapShot.abd7(x int);
-- EXEC AutoTest.dbo.uspDropSnapShot @pMaxSchemaSizeMB = 1
--EXEC AutoTest.dbo.uspDropSnapShot @pTestConfigID = 1

--DELETE AutoTest.dbo.TestConfig;
--DELETE AutoTest.dbo.ColumnHistogram;
--DELETE AutoTest.dbo.TableProfile;
--DELETE AutoTest.dbo.ColumnProfile;

