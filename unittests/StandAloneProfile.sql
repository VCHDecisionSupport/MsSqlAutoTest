USE AutoTest
GO

DECLARE @DatabaseName varchar(500) = 'CommunityMart'
DECLARE @DatabaseID int;

SELECT @DatabaseID = DatabaseId
FROM DQMF.dbo.MD_Database
WHERE DatabaseName = @DatabaseName

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
