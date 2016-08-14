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
	@pTestConfigLogID int,
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
	SET @sql = FORMATMESSAGE(N'INSERT INTO AutoTest.dbo.TableProfile (TestConfigLogID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES(%i, %i, GETDATE(), %i)',@pTestConfigLogID, @table_row_count, @pTableProfileTypeID);
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

	SET @sql = FORMATMESSAGE('
	INSERT INTO AutoTest.dbo.ColumnProfile (ColumnName, ColumnCount, TableProfileID, ColumnProfileTypeID)  SELECT pvt.ColumnName, pvt.ColumnCount, %i AS TableProfileID, %i AS ColumnProfileTypeID FROM (SELECT %s FROM %s) sub UNPIVOT (ColumnCount FOR ColumnName IN (%s)) pvt
	', @tableProfileID, @pColumnProfileTypeID,@AggCols, @FullTargetTableName,@cols);
	EXEC AutoTest.dbo.uspLog @pMessage = @sql;
	RAISERROR(@sql, 0,0) WITH NOWAIT;
	EXEC(@sql);
	RAISERROR(@sql, 0,0) WITH NOWAIT;
	PRINT @sql;
--#endregion ColumnProfile

--#region ColumnHistogram
	DECLARE cur CURSOR
	FOR
	SELECT ColumnProfileID
		,ColumnName
		,ColumnCount
		,TableProfileID
		,ColumnProfileTypeID
	FROM AutoTest.dbo.ColumnProfile AS col_pro
	WHERE col_pro.TableProfileID = @tableProfileID

	OPEN cur;

	DECLARE
		@ColumnProfileID int
		,@ColumnName varchar(100)
		,@ColumnCount int
		--,@TableProfileID int
		,@ColumnProfileTypeID int

	FETCH NEXT FROM cur INTO 
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
		FETCH NEXT FROM cur INTO 
			@ColumnProfileID
			,@ColumnName
			,@ColumnCount
			,@TableProfileID
			,@ColumnProfileTypeID
	END


	CLOSE cur;
	DEALLOCATE cur;
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

DECLARE @pTestConfigLogID int = 25;
SELECT @pTestConfigLogID=MAX(TestConfigLogID) FROM AutoTest.dbo.TestConfigLog
SET @pTestConfigLogID = 25;
DECLARE @PreEtlKeyMisMatchSnapShotName varchar(100)
SELECT @PreEtlKeyMisMatchSnapShotName = RecordMatchSnapShotName
FROM AutoTest.dbo.TestConfigLog WHERE TestConfigLogID = @pTestConfigLogID


EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PreEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;