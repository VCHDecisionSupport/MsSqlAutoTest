USE TestLog
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
AS
BEGIN
	
DECLARE cur CURSOR
FOR 
SELECT col.name AS col_name
FROM sys.columns AS col
WHERE OBJECT_ID(@pTableName) = col.object_id;

DECLARE @col_name varchar(100);

OPEN cur;

FETCH NEXT FROM cur INTO @col_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT @col_name;
	DECLARE @sql varchar(max);
	IF @col_name LIKE '%ID'
	BEGIN
		SET @sql = FORMATMESSAGE('WITH cte AS (SELECT TOP (5) PERCENT ETLAuditID FROM %s ORDER BY NEWID()) UPDATE %s SET %s = target.%s - 1 FROM %s AS target JOIN cte ON target.ETLAuditID = cte.ETLAuditID;',@pTableName, @pTableName, @col_name, @col_name, @pTableName);
		RAISERROR(@sql, 0, 1)
		EXEC(@sql)
	END

	FETCH NEXT FROM cur INTO @col_name;
END

CLOSE cur;
DEALLOCATE cur;
END
GO
--#endregion CREATE/ALTER PROC

DECLARE @pTableName varchar(100) = '[TestLog].[SnapShot].[destTableName]';
EXEC dbo.uspDiffMaker @pTableName=@pTableName
