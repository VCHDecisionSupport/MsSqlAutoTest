--#region CREATE/ALTER PROC
USE DQMF
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspGetDataRequestID';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspGetDataRequestID
	@pServerName varchar(32),
	@pPackageName varchar(100),
	@pDataRequestID int OUTPUT
AS
BEGIN
	SET @pDataRequestID = 123;

END
GO
--#endregion CREATE/ALTER PROC
DECLARE @pDataRequestID int;
EXEC dbo.uspGetDataRequestID 'abc', 'sdfs', @pDataRequestID OUT
PRINT @pDataRequestID;