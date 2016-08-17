USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfig'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfig') IS NOT NULL
	DROP TABLE dbo.TestConfig;
GO
CREATE TABLE dbo.TestConfig (
	TestConfigID INT IDENTITY(1, 1) NOT NULL
	,TestTypeID INT NOT NULL -- FK to TestType
	,ObjectID INT NOT NULL -- FK to DQMF.dbo.MD_Object; null if AdHoc
	,PkgID INT NOT NULL -- FK to DQMF.dbo.AuditPackageExecution; null if AdHoc
	,TestConfigSourceID INT NOT NULL -- FK TestConfigSourceType
)
GO
ALTER TABLE dbo.TestConfig ADD CONSTRAINT TestConfig_PK PRIMARY KEY CLUSTERED (TestConfigID)
GO