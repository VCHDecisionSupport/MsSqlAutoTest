USE [DQMF]
GO


--:connect SPDBDECSUP04
--SELECT COUNT(DISTINCT CAST(ISNULL(AccountNum,'__null__') AS varchar(50)) + '||' + CAST(ISNULL(MRN,'__null__') AS varchar(50)) + '||' + CAST(ISNULL(Bed,'__null__') AS varchar(50)) + '||' + CAST(ISNULL(CensusDateID,'__null__') AS varchar(50)) + '||' + CAST(ISNULL(AttendDrID,'__null__') AS varchar(50))), COUNT(*)
--FROM DSDW.Adtc.CensusFact

SELECT pkg.PkgName, *
FROM DQMF.dbo.ETL_Package AS pkg
JOIN DQMF.dbo.ETL_PackageObject AS map
ON pkg.PkgID = map.PackageID
JOIN DQMF.dbo.MD_Object AS obj
ON obj.ObjectID = map.ObjectID
WHERE obj.ObjectPurpose = 'Fact'
AND obj.IsActive = 1
AND obj.IsObjectInDb = 1

-- TODO: Set parameter values here.
DECLARE @RC int
DECLARE @pPkgExecKey bigint
DECLARE @pParentPkgExecKey bigint
DECLARE @pPkgName varchar(100) = 'AutoTestTesting'
DECLARE @pPkgVersionMajor smallint
DECLARE @pPkgVersionMinor smallint
DECLARE @pIsProcessStart bit = 1
DECLARE @pIsPackageSuccessful bit
DECLARE @pPkgExecKeyOut int

EXECUTE DQMF.[dbo].[SetAuditPkgExecution] 
   @pPkgExecKey
  ,@pParentPkgExecKey
  ,@pPkgName
  ,@pPkgVersionMajor
  ,@pPkgVersionMinor
  ,@pIsProcessStart
  ,@pIsPackageSuccessful
  ,@pPkgExecKeyOut OUTPUT

--EXEC AutoTest.dbo.uspInitPkgRegression @pPkgExecKey = @pPkgExecKeyOut

SET @pPkgExecKeyOut = 313160
--EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = @pPkgExecKeyOut

