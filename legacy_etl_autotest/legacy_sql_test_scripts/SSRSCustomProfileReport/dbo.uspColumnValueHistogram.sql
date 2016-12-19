--#region CREATE/ALTER PROC
USE DSDW
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspColumnValueHistogram';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspColumnValueHistogram
AS
BEGIN
	DECLARE @sql nvarchar(max);

	
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspColumnValueHistogram
