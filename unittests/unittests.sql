-- get last PkgExecKey
DECLARE @PkgExecKey int;
SELECT @PkgExecKey=MAX(PkgExecKey) FROM AUtoTest.dbo.TestConfig

-- uspCreateQuerySnapShot
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


-- uspGetColumnNames
DECLARE 
	@pDatabaseName varchar(100) = 'Lien'
	,@pSchemaName varchar(100) = 'Adtc'
	,@pObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pIntersectingDatabaseName varchar(100) = 'Lien'
	,@pIntersectingSchemaName varchar(100) = 'Adtc'
	,@pIntersectingObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pFmt varchar(max) = 'pre.%s,'
	,@pColStr varchar(max)
--SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'
--EXEC dbo.uspGetColumnNames 
--	@pDatabaseName
--	,@pSchemaName
--	,@pObjectName
--	,@pFmt = @pFmt
--	,@pColStr = @pColStr OUTPUT

--PRINT @pColStr

-- EXEC dbo.uspGetColumnNames @pDatabaseName='AutoTest', @pSchemaName='SnapShot', @pObjectName='PreEtl_TestConfigID82', @pFmt='%s,', @pColStr=@pColStr OUT

--PRINT @pcolstr + @pcolstr


-- uspPkgRegressionTest
GO
DECLARE @PkgExecKey int;
SELECT @PkgExecKey=MAX(PkgExecKey) FROM AUtoTest.dbo.TestConfig
SELECT * FROM AUtoTest.dbo.TestConfig
EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = 313210

-- uspRegressionTest
EXEC AutoTest.dbo.uspDataCompare @pTestConfigID = 1

GO
DECLARE @pColStr varchar(max) = ''
EXEC dbo.uspGetColumnNames @pDatabaseName='AutoTest', @pSchemaName='SnapShot', @pObjectName='PreEtl_TestConfigID1', @pFmt='%s,', @pColStr=@pColStr OUT
PRINT @pColStr
GO

EXEC dbo.uspInitPkgRegression @pPkgExecKey = 313210