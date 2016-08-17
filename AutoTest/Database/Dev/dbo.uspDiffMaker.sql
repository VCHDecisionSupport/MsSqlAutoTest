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
	@pTableName varchar(100)
	,@pPercentError int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	SET @pPercentError = ISNULL(@pPercentError, 1);
	RAISERROR('
uspDiffMaker: TableName: %s (diff percent per column: %i%%)', 0, 1, @pTableName, @pPercentError) WITH NOWAIT;
	DECLARE @sql varchar(max);
	DECLARE @rowcount int;
SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT ETLAuditID FROM %s ORDER BY NEWID()) DELETE %s FROM %s AS target JOIN cte ON target.ETLAuditID = cte.ETLAuditID;',@pPercentError, @pTableName, @pTableName, @pTableName);
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql)
		SET @rowcount = @@ROWCOUNT;
		RAISERROR('
	rowcount: %i', 0, 1, @rowcount) WITH NOWAIT;

DECLARE @table TABLE (
	ColumnName varchar(100)
);

DECLARE @DatabaseName varchar(100) = PARSENAME(@pTableName,3);
DECLARE @SchemaName varchar(100) = PARSENAME(@pTableName,2);
DECLARE @TableName varchar(100) = PARSENAME(@pTableName,1);
DECLARE @cols varchar(max);


EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@DatabaseName
	,@pSchemaName=@SchemaName
	,@pObjectName=@TableName
	,@pColStr=@cols OUTPUT
	,@pSkipPkHash = 1

DECLARE cur CURSOR
FOR 
SELECT item AS col_name
FROM dbo.strSplit(@cols, ',');

DECLARE @col_name varchar(100);

OPEN cur;

FETCH NEXT FROM cur INTO @col_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT @col_name;
	IF @col_name LIKE '%ID'-- AND @col_name NOT LIKE 'ETLAuditID'
	BEGIN
		SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (%i) PERCENT ETLAuditID FROM %s ORDER BY NEWID()) UPDATE %s SET %s = target.%s * - 1 FROM %s AS target JOIN cte ON target.ETLAuditID = cte.ETLAuditID;',@pPercentError, @pTableName, @pTableName, @col_name, @col_name, @pTableName);
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql)
		SET @rowcount = @@ROWCOUNT;
		RAISERROR('rowcount: %i', 0, 1, @rowcount) WITH NOWAIT;
	END

	FETCH NEXT FROM cur INTO @col_name;
END

CLOSE cur;
DEALLOCATE cur;
SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
RAISERROR('!uspDiffMaker: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC

--DECLARE @pTableName varchar(100) = '[TestLog].[SnapShot].[destTableName]';

--EXEC AutoTest.dbo.uspDiffMaker @pTableName='CommunityMart.dbo.SchoolHistoryFact'
