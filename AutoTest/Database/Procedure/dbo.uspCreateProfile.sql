USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateProfile';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateProfile
	@pTestConfigID int,
	@pTargetDatabaseName nvarchar(200) = 'AutoTest',
	@pTargetSchemaName nvarchar(200) = 'SnapShot',
	@pTargetTableName nvarchar(200),
	@pTableProfileTypeID int,
	@pColumnProfileTypeID int,
	@pColumnHistogramTypeID int,
	@pSubQueryFilter nvarchar(max) = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	RAISERROR('      uspCreateProfile: %s (@pTableProfileTypeID: %i)', 0, 1, @pTargetTableName, @pTableProfileTypeID) WITH NOWAIT;
	
	DECLARE @vsql varchar(max);
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	-- objectID
	
	-- not used but allows for customization
	SELECT @pSubQueryFilter = ISNULL(@pSubQueryFilter, '')

	DECLARE @full_table_name varchar(200) = FORMATMESSAGE('%s.%s.%s',@pTargetDatabaseName,@pTargetSchemaName, @pTargetTableName)
	 RAISERROR('full_table_name: %s',0,0,@full_table_name) WITH NOWAIT;

--#region TableProfile
	DECLARE @table_row_count int;
	SET @sql = FORMATMESSAGE(N'SELECT @table_row_countOUT = COUNT(*) FROM %s AS tab WHERE 1=1 %s', @full_table_name, @pSubQueryFilter);
	SET @param = '@table_row_countOUT int OUT';
	RAISERROR(@sql, 0, 1) WITH NOWAIT;

	EXEC sp_executesql @sql, @param, @table_row_countOUT = @table_row_count OUT;
	RAISERROR('      record count: %i', 0, 0, @table_row_count);
	SET @sql = FORMATMESSAGE(N'INSERT INTO AutoTest.dbo.TableProfile (TestConfigID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES(%i, %i, GETDATE(), %i)',@pTestConfigID, @table_row_count, @pTableProfileTypeID);
	RAISERROR(@sql, 0, 0) WITH NOWAIT;

	EXEC(@sql);
	DECLARE @tableProfileID int;
	SET @tableProfileID = @@IDENTITY;
	-- RAISERROR('tableProfileID: %i', 0, 1, @tableProfileID) WITH NOWAIT;
--#endregion TableProfile

--#region ColumnProfile
	DECLARE @pAggFmt nvarchar(max) = ', COUNT(DISTINCT %s) AS %s'
	DECLARE @AggCols nvarchar(max);
	DECLARE @cols nvarchar(max);
	EXEC dbo.uspGetColumnNames 
	@pDatabaseName='AutoTest'
	,@pSchemaName='SnapShot'
	,@pObjectName=@pTargetTableName
	,@pFmt=@pAggFmt
	,@pColStr=@AggCols OUTPUT
	,@pSkipPkHash = 1
	--RAISERROR(@AggCols, 0,0) WITH NOWAIT;

	EXEC dbo.uspGetColumnNames 
	@pDatabaseName='AutoTest'
	,@pSchemaName='SnapShot'
	,@pObjectName=@pTargetTableName
	,@pColStr=@cols OUTPUT
	,@pSkipPkHash = 1
	--RAISERROR(@cols, 0,0) WITH NOWAIT;
		
	DECLARE @FullTargetTableName varchar(300) = 'AutoTest.SnapShot.'+@pTargetTableName

	-- nvarchar(max) too small too hold query so can't use FORMATMESSAGE; use REPLACE to keep query string in varchar(max)
	SET @vsql = '
	INSERT INTO AutoTest.dbo.ColumnProfile 
	(ColumnName, ColumnCount, TableProfileID, ColumnProfileTypeID)  
	SELECT pvt.ColumnName, pvt.ColumnCount, <TableProfileID> AS TableProfileID, <ColumnProfileTypeID> AS ColumnProfileTypeID 
	FROM (SELECT 
		<AggregatedColumns> 
	FROM <SnapShotName>) sub 
	UNPIVOT (ColumnCount FOR ColumnName IN (
		<columns>
	)) pvt
	'
	SET @vsql = REPLACE(@vsql, '<TableProfileID>', @tableProfileID)
	SET @vsql = REPLACE(@vsql, '<ColumnProfileTypeID>', @pColumnProfileTypeID)
	SET @vsql = REPLACE(@vsql, '<AggregatedColumns>', @AggCols)
	SET @vsql = REPLACE(@vsql, '<columns>', @cols)
	SET @vsql = REPLACE(@vsql, '<SnapShotName>', @FullTargetTableName)

	--SET @sql = FORMATMESSAGE('
	--INSERT INTO AutoTest.dbo.ColumnProfile 
	--(ColumnName, ColumnCount, TableProfileID, ColumnProfileTypeID)  
	--SELECT pvt.ColumnName, pvt.ColumnCount, %i AS TableProfileID, %i AS ColumnProfileTypeID 
	--FROM (SELECT 
	--	%s 
	--FROM %s) sub 
	--UNPIVOT (ColumnCount FOR ColumnName IN (
	--	%s
	--)) pvt
	--', @tableProfileID, @pColumnProfileTypeID,@AggCols, @FullTargetTableName,@cols);
	RAISERROR(@vsql, 0,0) WITH NOWAIT;
	EXEC(@vsql);
--#endregion ColumnProfile

--#region ColumnHistogram
IF (SELECT CURSOR_STATUS('global','pro_cur')) >= -1
BEGIN
	RAISERROR('pro_cur EXISTS',0,0) WITH NOWAIT
	IF (SELECT CURSOR_STATUS('global','pro_cur')) > -1
	BEGIN
		RAISERROR('pro_cur is OPEN',0,0) WITH NOWAIT
		CLOSE pro_cur
   END
DEALLOCATE pro_cur
END

	DECLARE pro_cur CURSOR
	FOR
	SELECT ColumnProfileID
		,ColumnName
		,ColumnCount
		,TableProfileID
		,ColumnProfileTypeID
	FROM AutoTest.dbo.ColumnProfile AS col_pro
	WHERE col_pro.TableProfileID = @tableProfileID

	OPEN pro_cur;

	DECLARE
		@ColumnProfileID int
		,@ColumnName varchar(100)
		,@ColumnCount int
		--,@TableProfileID int
		,@ColumnProfileTypeID int

	FETCH NEXT FROM pro_cur INTO 
		@ColumnProfileID
		,@ColumnName
		,@ColumnCount
		,@TableProfileID
		,@ColumnProfileTypeID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		IF @ColumnCount < 1000 
		BEGIN
			-- RAISERROR('creating ColumnHistogram',0,1) WITH NOWAIT;
			EXEC dbo.uspInsColumnHistogram 
				@pColumnProfileID = @ColumnProfileID,
				@pTargetDatabaseName = @pTargetDatabaseName,
				@pTargetSchemaName = @pTargetSchemaName,
				@pTargetTableName = @pTargetTableName,
				@pTargetColumnName = @ColumnName,
				@pSubQueryFilter = @pSubQueryFilter,
				@pColumnHistogramTypeID = @pColumnHistogramTypeID
			-- RAISERROR('ColumnHistogram complete',0,1) WITH NOWAIT;

		END
		FETCH NEXT FROM pro_cur INTO 
			@ColumnProfileID
			,@ColumnName
			,@ColumnCount
			,@TableProfileID
			,@ColumnProfileTypeID
	END


	CLOSE pro_cur;
	DEALLOCATE pro_cur;
--#endregion ColumnHistogram

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('      !uspCreateProfile: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
DECLARE @PreEtlKeyMisMatchTableProfileTypeID int;
DECLARE @PreEtlKeyMisMatchColumnProfileTypeID int;
DECLARE @PreEtlKeyMisMatchColumnHistogramTypeID int;
SELECT @PreEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PreEtlKeyMisMatchTableProfile'
SELECT @PreEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PreEtlKeyMisMatchColumnProfile'
SELECT @PreEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMisMatchColumnHistogram'

DECLARE @pTestConfigID int = 25;
SELECT @pTestConfigID=MAX(TestConfigID) FROM AutoTest.dbo.TestConfig
SET @pTestConfigID = 25;
DECLARE @PreEtlKeyMisMatchSnapShotName varchar(100)
SELECT @PreEtlKeyMisMatchSnapShotName = RecordMatchSnapShotName
FROM AutoTest.dbo.TestConfig WHERE TestConfigID = @pTestConfigID


--EXEC AutoTest.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PreEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;