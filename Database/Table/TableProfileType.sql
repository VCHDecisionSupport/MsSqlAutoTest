USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TableProfileType'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TableProfileType') IS NOT NULL
	DROP TABLE dbo.TableProfileType;
GO
CREATE TABLE dbo.TableProfileType (
	TableProfileTypeID INT IDENTITY(1, 1) NOT NULL
	,TableProfileTypeDesc VARCHAR(100) NOT NULL
)
GO
ALTER TABLE dbo.TableProfileType ADD CONSTRAINT TableProfileType_PK PRIMARY KEY CLUSTERED (TableProfileTypeID)
GO
INSERT INTO dbo.TableProfileType VALUES ('StandAloneTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('StandAloneViewTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('RecordMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('PreEtlKeyMisMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('PostEtlKeyMisMatchTableProfile')
INSERT INTO dbo.TableProfileType VALUES ('KeyMatchTableProfile')
GO