USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfig'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfig') IS NOT NULL
	DROP TABLE dbo.TestConfig;
GO
CREATE TABLE dbo.TestConfig (
	TestConfigID INT IDENTITY(1, 1) NOT NULL
	,TestTypeID INT NOT NULL
	,PreEtlSourceObjectFullName varchar(200) NOT NULL -- fully qualified name of table/view
	,PostEtlSourceObjectFullName varchar(200) NULL -- fully qualified name of table/view same as above if Etl Regression Test (ie not AdHoc)
	,TestDate datetime NOT NULL
	--,SnapShotBaseName varchar(200) NULL -- only null initially, suffix of names of tables in SnapShot schema
	,SnapShotBaseName AS 'TestConfigID'+CAST(TestConfigID AS varchar)
	,PreEtlSnapShotName AS 'PreEtl_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,PostEtlSnapShotName AS 'PostEtl_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,RecordMatchSnapShotName AS 'RecordMatch_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,PreEtlKeyMisMatchSnapShotName AS 'PreEtlKeyMisMatch_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,PostEtlKeyMisMatchSnapShotName AS 'PostEtlKeyMisMatch_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,KeyMatchSnapShotName AS 'KeyMatch_'+'TestConfigID'+CAST(TestConfigID AS varchar)
	,ObjectID INT NULL -- FK to DQMF.dbo.MD_Object; null if AdHoc
	,PkgExecKey INT NULL -- FK to DQMF.dbo.AuditPackageExecution; null if AdHoc
	,PreEtlSnapShotCreationElapsedSeconds int NULL -- time taken to create+populate snap shot table
	,PostEtlSnapShotCreationElapsedSeconds int NULL -- time taken to create+populate snap shot table
	,ComparisonRuntimeSeconds int NULL -- time taken to create+populate snap shot table
)
GO
ALTER TABLE dbo.TestConfig ADD CONSTRAINT TestConfig_PK PRIMARY KEY CLUSTERED (TestConfigID)
GO