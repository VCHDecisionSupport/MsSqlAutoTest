USE AutoTest
GO


--#region CREATE/ALTER PROC

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspDiffMaker';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
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
	SET @pPercentError = ISNULL(@pPercentError, 1);
	RAISERROR('
uspDiffMaker: TableName: %s (diff percent per column: %i%%)', 0, 1, @pObjectName, @pPercentError) WITH NOWAIT;
	DECLARE @sql varchar(max);
	DECLARE @rowcount int;
	DECLARE @pTableName varchar(500) = @pDatabaseName +'.'+ @pSchemaName +'.'+ @pObjectName
SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT ETLAuditID FROM %s) DELETE %s FROM %s AS target JOIN cte ON target.ETLAuditID = cte.ETLAuditID;',@pPercentError, @pTableName, @pTableName, @pTableName);
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql)
		SET @rowcount = @@ROWCOUNT;
		RAISERROR('
	delete rowcount: %i', 0, 1, @rowcount) WITH NOWAIT;

DECLARE @table TABLE (
	ColumnName varchar(100)
);

DECLARE @cols varchar(max);


EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@pDatabaseName
	,@pSchemaName=@pSchemaName
	,@pObjectName=@pObjectName
	,@pColStr=@cols OUTPUT
	,@pSkipPkHash = 1

		RAISERROR('
	@pColStr: %s', 0, 1, @cols) WITH NOWAIT;


DECLARE columnCursor CURSOR
FOR 
SELECT item
FROM dbo.strSplit(@cols, ',')
--ORDER BY NEWID()

RAISERROR('im not here', 0, 1) WITH NOWAIT;

DECLARE @col_name varchar(100);

OPEN columnCursor;

FETCH NEXT FROM columnCursor INTO @col_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @col_name;
	IF @col_name LIKE '%ID'-- AND @col_name NOT LIKE 'ETLAuditID'
	BEGIN
		SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT ETLAuditID FROM %s) UPDATE %s SET %s = target.%s * - 1 FROM %s AS target JOIN cte ON target.ETLAuditID = cte.ETLAuditID;',@pPercentError, @pTableName, @pTableName, @col_name, @col_name, @pTableName);
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql)
		SET @rowcount = @@ROWCOUNT;
		RAISERROR('update %s rowcount: %i', 0, 1, @col_name, @rowcount) WITH NOWAIT;
	END

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

--USE [AutoTest]
--GO

--DECLARE @pDatabaseName nvarchar(200) = 'CommunityMart'
--DECLARE @pSchemaName nvarchar(200) = 'dbo'
--DECLARE @pObjectName nvarchar(200) = 'ImmAdverseEventFact'
--DECLARE @pPercentError int

---- TODO: Set parameter values here.

--EXECUTE [dbo].[uspDiffMaker] 
--   @pDatabaseName
--  ,@pSchemaName
--  ,@pObjectName
--  ,@pPercentError
--GO

