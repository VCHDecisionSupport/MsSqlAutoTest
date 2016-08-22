USE AutoTest
GO

--#region get last PkgExecKey
SELECT TOP 20 
	pkg.PkgName
	,*
FROM DQMF.dbo.ETL_PackageObject AS pkgobj
JOIN DQMF.dbo.ETL_Package AS pkg
ON pkgobj.PackageID = pkg.PkgID
--#endregion get last PkgExecKey

--#region SetAuditPkgExecution
IF 1=1
BEGIN
DECLARE @pPkgExecKeyout varchar(max);
EXEC DQMF.dbo.[SetAuditPkgExecution]
            @pPkgExecKey = null
           ,@pParentPkgExecKey = null
           ,@pPkgName = 'AutoTestTesting3'
           ,@pPkgVersionMajor = 1
           ,@pPkgVersionMinor  = 1
           ,@pIsProcessStart  = 1
           ,@pIsPackageSuccessful  = 0
           ,@pPkgExecKeyout  = @pPkgExecKeyout   output
SELECT @pPkgExecKeyout AS PkgExecKey
END
GO
--#endregion SetAuditPkgExecution

--#region uspInitPkgRegression
IF 1=2
BEGIN
EXEC dbo.uspInitPkgRegression @pPkgExecKey = 313235
DEClaRE @pPkgExecKeyout  bigint
END
GO
--#endregion uspInitPkgRegression



--EXEC xp_ReadErrorLog 0, 1, N'this', N'is', '20160701', NULL, 'DESC'


--#region uspPkgRegressionTest
IF 1=2
BEGIN
DECLARE @PkgExecKey int;
SELECT @PkgExecKey=MAX(PkgExecKey) FROM AUtoTest.dbo.TestConfig;
SELECT PkgExecKey, * FROM AUtoTest.dbo.TestConfig;
EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = 313235
END
GO
--#endregion uspPkgRegressionTest


--#region uspDataCompare
IF 1=2
BEGIN
EXEC AutoTest.dbo.uspDataCompare @pTestConfigID = 21;
END
GO
--#endregion uspDataCompare

--#region uspCreateQuerySnapShot
IF 1=2
BEGIN
DECLARE 
	@pPreEtlDatabaseName varchar(100) = 'Lien'
	,@pPreEtlSchemaName varchar(100) = 'Adtc'
	,@pPreEtlTableName varchar(100) = 'SM_02_DischargeFact'
	,@pPostEtlDatabaseName varchar(100) = 'Lien'
	,@pPostEtlSchemaName varchar(100) = 'Adtc'
	,@pPostEtlTableName varchar(100) = 'SM_03_DischargeFact'
	,@pObjectPkColumns varchar(100) = 'PatientID, AccountNum'
DECLARE @pQuery varchar(max),
	@pKeyColumns varchar(max) = @pObjectPkColumns,
	@pHashKeyColumns varchar(max) = @pObjectPkColumns,
	@pDestDatabaseName varchar(100) = 'AutoTest',
	@pDestSchemaName varchar(100) = 'SnapShot',
	@pDestTableName varchar(100) = 'waldo'

SET @pQuery = FORMATMESSAGE('SELECT * FROM %s.%s.%s', @pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName)
EXEC AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@pQuery, @pKeyColumns=@pKeyColumns, @pHashKeyColumns=@pHashKeyColumns, @pDestDatabaseName=@pDestDatabaseName,@pDestSchemaName=@pDestSchemaName,@pDestTableName=@pDestTableName
END
GO
--#endregion uspCreateQuerySnapShot



--#region uspGetColumnNames
IF 1=2
BEGIN
DECLARE 
	@pDatabaseName varchar(100) = 'Lien'
	,@pSchemaName varchar(100) = 'Adtc'
	,@pObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pIntersectingDatabaseName varchar(100) = 'Lien'
	,@pIntersectingObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pIntersectingSchemaName varchar(100) = 'Adtc'
	,@pFmt varchar(max) = 'pre.%s,'
	,@pColStr varchar(max)
SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'
EXEC dbo.uspGetColumnNames 
	@pDatabaseName
	,@pSchemaName
	,@pObjectName
	,@pFmt = @pFmt
	,@pColStr = @pColStr OUTPUT

PRINT @pColStr
END
GO
--#endregion uspGetColumnNames

--#region Stand Alone Profile
IF 1=2
BEGIN
DECLARE @TestTypeID int;
DECLARE @TableProfileTypeID int;
DECLARE @ColumnProfileTypeID int;
DECLARE @ColumnHistogramTypeID int;
SELECT @TestTypeID = TestTypeID FROM AutoTest.dbo.TestType WHERE TestTypeDesc = 'StandAloneTableProfile'
SELECT @TableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'StandAloneTableProfile'
SELECT @ColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'StandAloneColumnProfile'
SELECT @ColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'StandAloneColumnHistogram'



DECLARE @pTestConfigID int = 25;
SELECT @pTestConfigID=MAX(TestConfigID) FROM AutoTest.dbo.TestConfig
SET @pTestConfigID = 25;
DECLARE @PreEtlKeyMisMatchSnapShotName varchar(100)
SELECT @PreEtlKeyMisMatchSnapShotName = RecordMatchSnapShotName
FROM AutoTest.dbo.TestConfig WHERE TestConfigID = @pTestConfigID
END
GO
--#endregion Stand Alone Profile

--#region uspGetKey
IF 1=2
BEGIN
DECLARE @KeyColumns varchar(max) = '';
EXEC AutoTest.dbo.uspGetKey 
	@pDatabaseName = 'AutoTest',
	@pSchemaName = 'SnapShot',
	@pObjectName = 'PreEtl_TestConfigID1',
	@pFmt = '%s,',
	@pColStr = @KeyColumns OUTPUT
PRINT @KeyColumns;
END
GO
--#endregion uspGetKey

--#region clean 
IF 1=2
BEGIN
	EXEC AutoTest.dbo.uspDropSnapShot @pMaxSchemaSizeMB=0
	DELETE AutoTest.dbo.TestConfig
	DELETE AutoTest.dbo.TableProfile
	DELETE AutoTest.dbo.ColumnProfile
	DELETE AutoTest.dbo.ColumnHistogram
END
GO
--#endregion clean
