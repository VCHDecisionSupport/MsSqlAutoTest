USE AutoTest
GO


IF OBJECT_ID('dbo.Log') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.Log'
	DROP TABLE dbo.Log
END
GO

PRINT 'CREATE TABLE dbo.Log'
CREATE TABLE dbo.Log (
	Message varchar(max)
	,LogDate datetime
);


--#region CREATE/ALTER PROC dbo.uspLog
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspLog';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspLog
	@pMessage varchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspLog'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	INSERT INTO AutoTest.dbo.Log VALUES(@pMessage,GETDATE());

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspLog: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	--SELECT * FROM AutoTest.dbo.Log ORDER BY LogDate DESC;
	RETURN(@runtime);

END
GO
--#endregion CREATE/ALTER PROC dbo.uspLog
--EXEC dbo.uspLog @pMessage = 'testing123'
