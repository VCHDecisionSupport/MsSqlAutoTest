USE DQMF
GO
SET NOCOUNT ON;

DELETE AutoTest.dbo.TestConfig;
--DELETE AutoTest.dbo.DataRequestTestConfig;
DELETE DQMF.dbo.ETL_PackageObject;

DECLARE @PkgName varchar(100) = 'PopulateCommunityMart'
DECLARE @tableName varchar(100) = 'AssessmentContactFact'
DECLARE @databaseName varchar(100) = 'CommunityMart'
DECLARE @pPKField varchar(100);

DECLARE @pPkgId int
	,@pObjectID int
--	,@pDataRequestID int = 123

SELECT @pPkgId = PkgID
FROM DQMF.dbo.ETL_Package
WHERE PkgName = @PkgName

SELECT @pObjectID = ObjectID, @pPKField=obj.ObjectPKField
FROM DQMF.dbo.MD_Object AS obj
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
WHERE 1=1
AND ObjectPhysicalName = @tableName
AND db.DatabaseName = @databaseName

SELECT 
	@PkgName AS PkgName
	,@pPkgID AS PkgID
	,@databaseName AS databaseName
	,@tableName AS tableName
	--,@pObjectID AS ObjectID
	--,@pDataRequestID AS DataRequestID

--INSERT INTO TestLog.dbo.DataRequestTestConfig VALUES(@pDataRequestID, @pPkgId, @pObjectID);
INSERT INTO DQMF.dbo.ETL_PackageObject VALUES(@pPkgId, @pObjectID);

DECLARE
    @pPkgExecKey bigint = null
    ,@pParentPkgExecKey bigint = null
    ,@pPkgName varchar(100) = 'PopulateCommunityMart'
    ,@pPkgVersionMajor smallint = 4
    ,@pPkgVersionMinor smallint = 0
    ,@pIsProcessStart bit = 1 -- = 1
    ,@pIsPackageSuccessful bit = NULL
	,@pPkgExecKeyOut int
	,@pDoRegression bit = 1

exec DQMF.dbo.[gcSetAuditPkgExecution]
            @pPkgExecKey = @pPkgExecKey
           ,@pParentPkgExecKey = @pParentPkgExecKey
           ,@pPkgName = @pPkgName
           ,@pPkgVersionMajor = @pPkgVersionMajor
           ,@pPkgVersionMinor  = @pPkgVersionMinor
           ,@pIsProcessStart  = @pIsProcessStart
           ,@pIsPackageSuccessful  = @pIsPackageSuccessful
           ,@pPkgExecKeyout  = @pPkgExecKeyout   output
		   ,@pDoRegression = @pDoRegression

SELECT @pPkgExecKeyout AS PkgExecKey

SET @tableName = FORMATMESSAGE('TestLog.SnapShot.PreEtl%sPkgExecKey%i', @tableName ,@pPkgExecKeyout);
EXEC TestLog.dbo.uspDiffMaker @pTableName=@tableName
SET @tableName = PARSENAME(@tableName,1)
--EXEC TestLog.dbo.uspRebuildPK @pPkField=@pPKField,@pDestTableName=@tableName

SET @pIsProcessStart = 0;
SET @pIsPackageSuccessful = 1;
exec DQMF.dbo.[gcSetAuditPkgExecution]
            @pPkgExecKey = @pPkgExecKeyout
           ,@pParentPkgExecKey = @pParentPkgExecKey
           ,@pPkgName = @pPkgName
           ,@pPkgVersionMajor = @pPkgVersionMajor
           ,@pPkgVersionMinor  = @pPkgVersionMinor
           ,@pIsProcessStart  = @pIsProcessStart
           ,@pIsPackageSuccessful  = @pIsPackageSuccessful
           ,@pPkgExecKeyout  = @pPkgExecKeyout output
		   ,@pDoRegression = @pDoRegression