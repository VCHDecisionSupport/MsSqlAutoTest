--#region CREATE/ALTER PROC dbo.uspDropSnapShot
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
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspDropSnapShot
'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE 
		@DatabaseName varchar(100) = 'AutoTest'
		,@SchemaName varchar(100) = 'SnapShot'
		,@TableName varchar(100) = @pTableName
	DECLARE @FullName varchar(300) = @DatabaseName +'.'+@SchemaName +'.'+@TableName
	IF @pTableName IS NULL
	BEGIN
		SET @sql = FORMATMESSAGE('IF OBJECT_SCHEMA_NAME(OBJECT_ID(''?'')) = ''%s'' BEGIN DROP TABLE %s.?; PRINT ''?''+'' dropped''; END',@SchemaName, @DatabaseName, @FullName)
		EXEC sp_MSforeachtable @command1 = @sql
	END
	ELSE 
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;',@FullName);
		EXEC(@sql);
	END

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDropSnapShot
	: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspDropSnapShot
 --EXEC AutoTest.dbo.uspDropSnapShot

--DELETE AutoTest.dbo.TestConfig;
--DELETE AutoTest.dbo.ColumnHistogram;
--DELETE AutoTest.dbo.TableProfile;
--DELETE AutoTest.dbo.ColumnProfile;

