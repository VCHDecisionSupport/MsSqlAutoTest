USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.ColumnProfileType'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.ColumnProfileType') IS NOT NULL
	DROP TABLE dbo.ColumnProfileType;
GO
CREATE TABLE dbo.ColumnProfileType (
	ColumnProfileTypeID INT IDENTITY(1, 1) NOT NULL
	,ColumnProfileTypeDesc VARCHAR(100) NOT NULL
)
GO
ALTER TABLE dbo.ColumnProfileType ADD CONSTRAINT ColumnProfileType_PK PRIMARY KEY CLUSTERED (ColumnProfileTypeID)
GO
INSERT INTO dbo.ColumnProfileType VALUES ('StandAloneColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('RecordMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('PreEtlKeyMisMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('PostEtlKeyMisMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('KeyMatchValueMatchColumnProfile');
INSERT INTO dbo.ColumnProfileType VALUES ('KeyMatchValueMisMatchColumnProfile');
GO