USE DQMF
GO
SET NOCOUNT ON;

--#region AdHocDataCompare Tests
-- clean up
DELETE AutoTest.dbo.TableProfile
DELETE AutoTest.dbo.ColumnProfile
DELETE AutoTest.dbo.ColumnHistogram
EXEC AutoTest.dbo.uspDropSnapShot
-- do tests
DECLARE 
	@pPreEtlDatabaseName varchar(100) = 'Lien'
	,@pPreEtlSchemaName varchar(100) = 'Adtc'
	,@pPreEtlTableName varchar(100) = 'SM_02_DischargeFact'
	,@pPostEtlDatabaseName varchar(100) = 'Lien'
	,@pPostEtlSchemaName varchar(100) = 'Adtc'
	,@pPostEtlTableName varchar(100) = 'SM_03_DischargeFact'
	,@pObjectPkColumns varchar(100) = 'PatientID, AccountNum'
EXEC AutoTest.dbo.uspAdHocDataCompare 
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns

SET @pPreEtlTableName = 'SM_02_DischargeFact'
SET @pPostEtlTableName = 'SM_03_DischargeFact'
SET @pObjectPkColumns = 'AccountNum'
EXEC AutoTest.dbo.uspAdHocDataCompare 
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns

SET @pPreEtlTableName = 'SM_02_AdmissionFact'
SET @pPostEtlTableName = 'SM_03_AdmissionFact'
SET @pObjectPkColumns = 'AccountNum'
EXEC AutoTest.dbo.uspAdHocDataCompare 
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns

SET @pPreEtlTableName = 'SM_02_AdmissionFact'
SET @pPostEtlTableName = 'SM_04_AdmissionFact'
SET @pObjectPkColumns = 'AccountNum'
EXEC AutoTest.dbo.uspAdHocDataCompare 
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns
--#endregion AdHocDataCompare Tests



--DELETE AutoTest.dboTestConfigLog 
----DELETE AutoTest.dbo.DataRequestTestConfig;
--DELETE DQMF.dbo.ETL_PackageObject;

--DECLARE @PkgName varchar(100) = 'PopulateCommunityMart'
--DECLARE @tableName varchar(100) = 'AssessmentContactFact'
--DECLARE @databaseName varchar(100) = 'CommunityMart'
--DECLARE @pPKField varchar(100);

--DECLARE @pPkgId int
--	,@pObjectID int
----	,@pDataRequestID int = 123

--SELECT @pPkgId = PkgID
--FROM DQMF.dbo.ETL_Package
--WHERE PkgName = @PkgName

--SELECT @pObjectID = ObjectID, @pPKField=obj.ObjectPKField
--FROM DQMF.dbo.MD_Object AS obj
--JOIN DQMF.dbo.MD_Database AS db
--ON obj.DatabaseId = db.DatabaseId
--WHERE 1=1
--AND ObjectPhysicalName = @tableName
--AND db.DatabaseName = @databaseName

--SELECT 
--	@PkgName AS PkgName
--	,@pPkgID AS PkgID
--	,@databaseName AS databaseName
--	,@tableName AS tableName
--	--,@pObjectID AS ObjectID
--	--,@pDataRequestID AS DataRequestID

----INSERT INTO TestLog.dbo.DataRequestTestConfigLog VALUES(@pDataRequestID, @pPkgId, @pObjectID);
--INSERT INTO DQMF.dbo.ETL_PackageObject VALUES(@pPkgId, @pObjectID);

--DECLARE
--    @pPkgExecKey bigint = null
--    ,@pParentPkgExecKey bigint = null
--    ,@pPkgName varchar(100) = 'PopulateCommunityMart'
--    ,@pPkgVersionMajor smallint = 4
--    ,@pPkgVersionMinor smallint = 0
--    ,@pIsProcessStart bit = 1 -- = 1
--    ,@pIsPackageSuccessful bit = NULL
--	,@pPkgExecKeyOut int
--	,@pDoRegression bit = 1

--exec DQMF.dbo.[gcSetAuditPkgExecution]
--            @pPkgExecKey = @pPkgExecKey
--           ,@pParentPkgExecKey = @pParentPkgExecKey
--           ,@pPkgName = @pPkgName
--           ,@pPkgVersionMajor = @pPkgVersionMajor
--           ,@pPkgVersionMinor  = @pPkgVersionMinor
--           ,@pIsProcessStart  = @pIsProcessStart
--           ,@pIsPackageSuccessful  = @pIsPackageSuccessful
--           ,@pPkgExecKeyout  = @pPkgExecKeyout   output
--		   ,@pDoRegression = @pDoRegression

--SELECT @pPkgExecKeyout AS PkgExecKey

--SET @tableName = FORMATMESSAGE('TestLog.SnapShot.PreEtl%sPkgExecKey%i', @tableName ,@pPkgExecKeyout);
--EXEC TestLog.dbo.uspDiffMaker @pTableName=@tableName
--SET @tableName = PARSENAME(@tableName,1)
----EXEC TestLog.dbo.uspRebuildPK @pPkField=@pPKField,@pDestTableName=@tableName

--SET @pIsProcessStart = 0;
--SET @pIsPackageSuccessful = 1;
--exec DQMF.dbo.[gcSetAuditPkgExecution]
--            @pPkgExecKey = @pPkgExecKeyout
--           ,@pParentPkgExecKey = @pParentPkgExecKey
--           ,@pPkgName = @pPkgName
--           ,@pPkgVersionMajor = @pPkgVersionMajor
--           ,@pPkgVersionMinor  = @pPkgVersionMinor
--           ,@pIsProcessStart  = @pIsProcessStart
--           ,@pIsPackageSuccessful  = @pIsPackageSuccessful
--           ,@pPkgExecKeyout  = @pPkgExecKeyout output
--		   ,@pDoRegression = @pDoRegression