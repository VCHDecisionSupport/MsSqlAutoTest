USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.ColumnProfile'
RAISERROR(@name,1,1) WITH NOWAIT;

IF OBJECT_ID('dbo.ColumnProfile') IS NOT NULL
	DROP TABLE dbo.ColumnProfile;
GO
CREATE TABLE dbo.ColumnProfile (
	ColumnProfileID INT IDENTITY(1, 1) NOT NULL
	,ColumnName varchar(200) NOT NULL
	,ColumnCount INT NOT NULL
	,TableProfileID INT NOT NULL
	,ColumnProfileTypeID INT NOT NULL
)
GO
ALTER TABLE dbo.ColumnProfile ADD CONSTRAINT ColumnProfile_PK PRIMARY KEY CLUSTERED (ColumnProfileID)
GO