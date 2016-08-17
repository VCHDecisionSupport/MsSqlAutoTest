USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestConfigSource'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestConfigSource') IS NOT NULL
	DROP TABLE dbo.TestConfigSource;
GO
CREATE TABLE dbo.TestConfigSource (
	TestConfigSourceID INT IDENTITY(1, 1) NOT NULL
	,TestConfigSourceDesc varchar(500) NOT NULL
)
GO
ALTER TABLE dbo.TestConfigSource ADD CONSTRAINT TestConfigSource_PK PRIMARY KEY CLUSTERED (TestConfigSourceID)
GO

INSERT INTO dbo.TestConfigSource VALUES ('User Specified')
INSERT INTO dbo.TestConfigSource VALUES ('Package Data Flow Destination Table')
INSERT INTO dbo.TestConfigSource VALUES ('DQMF Meta Data')
GO