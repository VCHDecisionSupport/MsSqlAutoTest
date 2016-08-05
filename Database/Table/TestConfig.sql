USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfig'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfig') IS NOT NULL
	DROP TABLE dbo.TestConfig;
GO
CREATE TABLE dbo.TestConfig (
	TestConfigID INT IDENTITY(1, 1) NOT NULL
	,DataRequestTestConfigID INT NULL
	,PkgID INT NULL
	,ObjectID INT NULL
	,PkgExecKey INT NULL
	,TestTypeID INT NOT NULL
	,DataRequestID INT NULL
	,PreEtlSnapShotSourceName varchar(200)
	,PostEtlSnapShotSourceName varchar(200)
)
GO
ALTER TABLE dbo.TestConfig ADD CONSTRAINT TestConfig_PK PRIMARY KEY CLUSTERED (TestConfigID)
GO