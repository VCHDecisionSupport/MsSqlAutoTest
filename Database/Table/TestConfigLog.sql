USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfigLog'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfigLog') IS NOT NULL
	DROP TABLE dbo.TestConfig;
GO
CREATE TABLE dbo.TestConfigLog (
	TestConfigLogID INT IDENTITY(1, 1) NOT NULL
	,DataRequestTestConfigLogID INT NULL
	,PkgID INT NULL
	,ObjectID INT NULL
	,PkgExecKey INT NULL
	,TestTypeID INT NOT NULL
	,DataRequestID INT NULL
	,PreEtlSnapShotSourceName varchar(200)
	,PostEtlSnapShotSourceName varchar(200)
)
GO
ALTER TABLE dbo.TestConfigLog ADD CONSTRAINT TestConfigLog_PK PRIMARY KEY CLUSTERED (TestConfigLogID)
GO