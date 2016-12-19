USE AutoTest
GO

DECLARE @name varchar(100) = 'dbo.TestType'
RAISERROR(@name,0,1) WITH NOWAIT;

IF OBJECT_ID('dbo.TestType') IS NOT NULL
	DROP TABLE dbo.TestType;
GO
CREATE TABLE dbo.TestType (TestTypeID INT IDENTITY(1, 1) NOT NULL, TestTypeDesc VARCHAR(100) NOT NULL)
GO
ALTER TABLE dbo.TestType ADD CONSTRAINT TestType_PK PRIMARY KEY CLUSTERED (TestTypeID)
GO
INSERT INTO dbo.TestType VALUES ('Not Tested')
INSERT INTO dbo.TestType VALUES ('RuntimeProfile')
INSERT INTO dbo.TestType VALUES ('RuntimeRegressionTest')
INSERT INTO dbo.TestType VALUES ('AdHocDataComparison')
INSERT INTO dbo.TestType VALUES ('AdHocDataProfile')
GO