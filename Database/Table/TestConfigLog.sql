USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfigLog'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfigLog') IS NOT NULL
	DROP TABLE dbo.TestConfigLog;
GO
CREATE TABLE dbo.TestConfigLog (
	TestConfigLogID INT IDENTITY(1, 1) NOT NULL
	,PreEtlSourceObjectFullName varchar(200) NOT NULL -- fully qualified name of table/view
	,PostEtlSourceObjectFullName varchar(200) NOT NULL -- fully qualified name of table/view same as above if Etl Regression Test (ie not AdHoc)
	,PreEtlSnapShotName varchar(200) NOT NULL -- name of table in SnapShot schema
	,PostEtlSnapShotName varchar(200) NOT NULL -- name of table in SnapShot schema
	,ObjectID INT NULL -- FK to DQMF.dbo.MD_Object; null if AdHoc
	,TestConfigID INT NULL -- FK to TestConfig; null if AdHoc
	,PkgExecKey INT NULL -- FK to DQMF.dbo.AuditPackageExecution; null if AdHoc
	,PreEtlSnapShotCreationElapsedSeconds int NULL -- time taken to create+populate snap shot table
	,PostEtlSnapShotCreationElapsedSeconds int NULL -- time taken to create+populate snap shot table
	,ComparisonRuntimeSeconds int NULL -- time taken to create+populate snap shot table
)
GO
ALTER TABLE dbo.TestConfigLog ADD CONSTRAINT TestConfigLog_PK PRIMARY KEY CLUSTERED (TestConfigLogID)
GO