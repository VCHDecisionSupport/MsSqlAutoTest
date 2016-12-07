USE AutoTest
GO


--#region CREATE/ALTER PROC

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspDiffMaker';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@name, 1, 1) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspDiffMaker
	@pDatabaseName nvarchar(200) = 'AutoTest',
	@pSchemaName nvarchar(200) = 'SnapShot',
	@pObjectName nvarchar(200)
	,@pPercentError int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	SET @pPercentError = ISNULL(@pPercentError, FLOOR(RAND()*10));
	DECLARE @pTableName varchar(500) = @pDatabaseName +'.'+ @pSchemaName +'.'+ @pObjectName;
	DECLARE @sql varchar(max);
	DECLARE @rowcount int;

	SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT __hashkey__ FROM %s) DELETE %s FROM %s AS target JOIN cte ON target.__hashkey__ = cte.__hashkey__;',@pPercentError, @pTableName, @pTableName, @pTableName);
	RAISERROR(@sql, 0, 1) WITH NOWAIT;
	EXEC(@sql)
	SET @rowcount = @@ROWCOUNT;
	EXEC dbo.uspLog @PkgExecKey = NULL, @TargetTableFullName = @pTableName, @TargetColumnName='DELETE ROWS',@PercentAffected = @pPercentError, @RowAffected = @rowcount;
	RAISERROR('AutoTest uspDataDiff: delete %s rowcount: %i (%i)', 0, 1, @pTableName, @rowcount, @pPercentError) WITH NOWAIT, LOG;


DECLARE @cols varchar(max);


EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@pDatabaseName
	,@pSchemaName=@pSchemaName
	,@pObjectName=@pObjectName
	,@pColStr=@cols OUTPUT
	,@pSkipPkHash = 1

		-- RAISERROR('@pColStr: %s', 0, 1, @cols) WITH NOWAIT;

DECLARE columnCursor CURSOR
FOR 
SELECT item
FROM dbo.strSplit(@cols, ',') AS csv
JOIN sys.columns AS cols
ON csv.Item = cols.name
JOIN sys.tables AS tab
ON cols.object_id = tab.object_id
AND tab.name = @pObjectName
JOIN sys.types AS typ
ON typ.system_type_id = cols.system_type_id
WHERE 1=1
AND cols.is_identity = 0
AND cols.name LIKE '%ID'
AND typ.name IN ('int','bigint')
ORDER BY NEWID()

DECLARE @col_name varchar(100),
	@col_count int = 0,
	@rand_col_count int = FLOOR(RAND()*4)

RAISERROR('AutoTest uspDataDiff: %s update %i columns', 0, 1, @pObjectName, @rand_col_count) WITH NOWAIT, LOG;

OPEN columnCursor;

FETCH NEXT FROM columnCursor INTO @col_name;
SET @rand_col_count = 0;
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @col_count < @rand_col_count
	BEGIN
	SELECT @col_name;
	SET @pPercentError = FLOOR(RAND()*10)
	SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT __hashkey__ FROM %s) UPDATE %s SET %s = target.%s * - 1 FROM %s AS target JOIN cte ON target.__hashkey__ = cte.__hashkey__;',@pPercentError, @pTableName, @pTableName, @col_name, @col_name, @pTableName);
	RAISERROR(@sql, 0, 1) WITH NOWAIT;
	EXEC(@sql)
	SET @rowcount = @@ROWCOUNT;
	EXEC dbo.uspLog @PkgExecKey = NULL, @TargetTableFullName = @pTableName, @TargetColumnName=@col_name,@PercentAffected = @pPercentError, @RowAffected = @rowcount;
	RAISERROR('AutoTest uspDataDiff: update %s.%s rowcount: %i (%i)', 0, 1, @pTableName, @col_name, @rowcount, @pPercentError) WITH NOWAIT, LOG;
	END
	SET @col_count = @col_count + 1
	FETCH NEXT FROM columnCursor INTO @col_name;
END

CLOSE columnCursor;
DEALLOCATE columnCursor;
SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
RAISERROR('!uspDiffMaker: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC



--#region diff maker loop
IF 1=2
BEGIN

DECLARE @PkgExecKey int = 313276

DECLARE diffCursor CURSOR
FOR
SELECT PreEtlSnapShotName
FROM DQMF.dbo.AuditPkgExecution AS pkglog
JOIN AutoTest.dbo.TestConfig AS tlog
ON pkglog.PkgExecKey = tlog.PkgExecKey
WHERE 1=1
AND tlog.PkgExecKey=@PkgExecKey



OPEN diffCursor;

DECLARE @RC int
DECLARE @pDatabaseName nvarchar(200) = 'AutoTest'
DECLARE @pSchemaName nvarchar(200) = 'SnapShot'
DECLARE @pObjectName nvarchar(200) = 'SchoolHistoryFact'
DECLARE @pPercentError int

FETCH NEXT FROM diffCursor INTO @pObjectName

-- TODO: Set parameter values here.
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @pDatabaseName;
	PRINT @pSchemaName;
	PRINT @pObjectName;

	EXECUTE @RC = AutoTest.[dbo].[uspDiffMaker] 
	   @pDatabaseName
	  ,@pSchemaName
	  ,@pObjectName
	  ,@pPercentError
	FETCH NEXT FROM diffCursor INTO @pObjectName

END

CLOSE diffCursor
DEALLOCATE diffCursor;
END
--#endregion diff maker loop

