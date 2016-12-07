USE TestLog
GO

SELECT dbo.ufnGetColumnNames(53913)



DECLARE @pDataRequestID int, @pPkgExecKey int, @pDataDesc varchar(100);
SET @pDataRequestID = 666;
SET @pPkgExecKey = 1;
SET @pDataDesc = 'DataDoom';
SELECT @pDataRequestID AS DataRequestTestConfigID, @pPkgExecKey AS PkgExecKey, @pDataDesc AS ObjectName, dbo.ufnGetSnapShotName(NULL, @pDataRequestID, @pDataDesc, @pPkgExecKey, NULL) AS ufnGetSnapShotName;


EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM CommunityMart.dbo.ReferralFact', @pPkField='SourceReferralID',@pDestTableName='TestSnapShot'


EXEC dbo.uspCreateMDObjectSnapShot @pObjectID = 53913, @pDestTableName = 'TestAssessmentContactSnapShot'


DECLARE @pPkgId int = 291
	,@pPkgExecKey int = 1
	,@pTestTypeDesc varchar(100) = 'hi there'


EXEC dbo.uspInsTestConfig 
	@pPkgId = @pPkgId
	,@pPkgExecKey = @pPkgExecKey
	,@pTestTypeDesc = @pTestTypeDesc
GO
SELECT * FROM dbo.TestConfig




