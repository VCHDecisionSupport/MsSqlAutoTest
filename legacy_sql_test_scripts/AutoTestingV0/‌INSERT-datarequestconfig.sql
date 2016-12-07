USE TestLog
GO


SELECT * FROM dbo.DataRequestTestConfig;
SELECT * FROM dbo.TestConfig;
GO
DELETE TestConfig;
DELETE DataRequestTestConfig;
GO

DECLARE @PkgName varchar(100) = 'PopulateCommunityMart'
DECLARE @tableName varchar(100) = 'AssessmentContactFact'
DECLARE @databaseName varchar(100) = 'CommunityMart'

DECLARE @pPkgId int
	,@pObjectID int
	,@pDataRequestID int;

SELECT @pPkgId = PkgID
FROM DQMF.dbo.ETL_Package
WHERE PkgName = @PkgName

SELECT @pObjectID = ObjectID
FROM DQMF.dbo.MD_Object AS obj
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
WHERE 1=1
AND ObjectPhysicalName = @tableName
AND db.DatabaseName = @databaseName

SET @pDataRequestID = 123;

RAISERROR('ObjectID: %i  PkgID: %i',0,1,@pObjectID, @pPkgId) WITH NOWAIT;

INSERT INTO DataRequestTestConfig VALUES(@pDataRequestID, @pPkgId, @pObjectID);
GO

SELECT * FROM dbo.DataRequestTestConfig;
SELECT * FROM dbo.TestConfig;