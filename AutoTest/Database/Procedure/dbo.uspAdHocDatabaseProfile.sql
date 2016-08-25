USE AutoTest
GO

DECLARE @pDatabaseName varchar(500) = 'CommunityMart'

--#region CREATE/ALTER PROC dbo.uspAdHocDatabaseProfile
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspAdHocDatabaseProfile';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspAdHocDatabaseProfile
	@pDatabaseName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspAdHocDatabaseProfile(%s)'
	RAISERROR(@fmt, 0, 1,@pDatabaseName) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE @DatabaseID int;

	SELECT @DatabaseID = DatabaseId
	FROM DQMF.dbo.MD_Database
	WHERE DatabaseName = @pDatabaseName

	DECLARE @ObjectID int;
	DECLARE @pTargetDatabaseName varchar(500);
	DECLARE @pTargetSchemaName varchar(500);
	DECLARE @pTargetTableName varchar(500);
	DECLARE @PreEtlSourceObjectFullName varchar(500);

	DECLARE cur cursor
	FOR
	SELECT 
		db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName
		,db.DatabaseName+'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName
		,obj.ObjectID
	FROM DQMF.dbo.MD_Object obj
	JOIN DQMF.dbo.MD_Database AS db
	ON obj.DatabaseID = db.DatabaseId
	WHERE 1=1
	AND db.DatabaseId = @DatabaseID

	OPEN cur;

	FETCH NEXT FROM cur INTO @pTargetDatabaseName,@pTargetSchemaName,@pTargetTableName,@PreEtlSourceObjectFullName,@ObjectID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		

		EXEC dbo.uspAdHocDataProfile
			@pDatabaseName = @pTargetDatabaseName,
			@pSchemaName = @pTargetSchemaName,
			@pTableName = @pTargetTableName,
			@pObjectID = @ObjectID

		FETCH NEXT FROM cur INTO @pTargetDatabaseName,@pTargetSchemaName,@pTargetTableName,@PreEtlSourceObjectFullName,@ObjectID
		


	END

	CLOSE cur;
	DEALLOCATE cur;

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspAdHocDatabaseProfile: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspAdHocDatabaseProfile
-- EXEC dbo.uspAdHocDatabaseProfile