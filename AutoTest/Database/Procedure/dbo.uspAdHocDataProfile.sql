USE AutoTest
GO

DECLARE @pDatabaseName varchar(500) = 'CommunityMart'

--#region CREATE/ALTER PROC dbo.uspAdHocDataProfile
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspAdHocDataProfile';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspAdHocDataProfile
	@pDatabaseName varchar(100) = NULL
	,@pSchemaName varchar(100) = NULL
	,@pViewTableName varchar(100) = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspAdHocDataProfile'
	SET @fmt = @fmt + CASE WHEN @pDatabaseName IS NULL THEN '
	All Databases' ELSE '
	Only Database ' + @pDatabaseName END 	
	SET @fmt = @fmt + CASE WHEN @pSchemaName IS NULL THEN '
	All Schemas' ELSE '
	Only Schema ' + @pSchemaName END 
	SET @fmt = @fmt + CASE WHEN @pViewTableName IS NULL THEN '
	All ViewTables' ELSE '
	Only ViewTable ' + @pViewTableName END 	
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;

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
	DECLARE @PostEtlSourceObjectFullName varchar(500);

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
	AND CASE WHEN @pDatabaseName IS NULL THEN '' 
			ELSE db.DatabaseName END = 
		CASE WHEN @pDatabaseName IS NULL THEN '' 
			ELSE @pDatabaseName END
	AND CASE WHEN @pSchemaName IS NULL THEN '' 
			ELSE obj.ObjectSchemaName END = 
		CASE WHEN @pSchemaName IS NULL THEN '' 
			ELSE @pSchemaName END
	AND CASE WHEN @pViewTableName IS NULL THEN '' 
			ELSE obj.ObjectPhysicalName END = 
		CASE WHEN @pViewTableName IS NULL THEN '' 
			ELSE @pViewTableName END
	AND obj.ObjectType IN ('Table', 'View')
	AND db.DatabaseName != 'DQMF'

	OPEN cur;

	FETCH NEXT FROM cur INTO @pTargetDatabaseName,@pTargetSchemaName,@pTargetTableName,@PostEtlSourceObjectFullName,@ObjectID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		

		EXEC AutoTest.dbo.uspAdHocTableViewProfile
			@pDatabaseName = @pTargetDatabaseName,
			@pSchemaName = @pTargetSchemaName,
			@pTableName = @pTargetTableName,
			@pObjectID = @ObjectID

		FETCH NEXT FROM cur INTO @pTargetDatabaseName,@pTargetSchemaName,@pTargetTableName,@PostEtlSourceObjectFullName,@ObjectID
		


	END

	CLOSE cur;
	DEALLOCATE cur;

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspAdHocDataProfile: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END TRY
BEGIN CATCH
	DECLARE @ErrorNumber int;
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorProcedure int;
	DECLARE @ErrorLine int;
	DECLARE @ErrorMessage varchar(max);
	DECLARE @UserMessage nvarchar(max);

	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorProcedure = ERROR_PROCEDURE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE()

	SET @UserMessage = FORMATMESSAGE('AutoTest proc ERROR: %s 
		Error Message: %s
		Line Number: %i
		Severity: %i
		State: %i
		Error Number: %i
	',@ErrorProcedure, @ErrorMessage, @ErrorNumber, @ErrorLine, @ErrorSeverity, @ErrorState, @ErrorNumber);

	RAISERROR(@UserMessage,0,1) WITH NOWAIT, LOG
END CATCH;
END
GO
--#endregion CREATE/ALTER PROC dbo.uspAdHocDataProfile
-- EXEC dbo.uspAdHocDataProfile