USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TableProfile'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TableProfile') IS NOT NULL
	DROP TABLE dbo.TableProfile;
GO
CREATE TABLE dbo.TableProfile (TableProfileID INT IDENTITY(1, 1) NOT NULL
	,TestConfigID INT NOT NULL
	,RecordCount INT NOT NULL
	,TableProfileDate DATETIME NOT NULL
	,TableProfileTypeID INT NOT NULL
)
GO
ALTER TABLE dbo.TableProfile ADD CONSTRAINT TableProfile_PK PRIMARY KEY CLUSTERED (TableProfileID)
GO