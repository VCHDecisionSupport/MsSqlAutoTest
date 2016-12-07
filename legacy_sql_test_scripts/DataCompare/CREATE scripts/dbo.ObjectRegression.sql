USE TestLog
GO

IF OBJECT_ID('dbo.ObjectRegression') IS NOT NULL
BEGIN
	PRINT 'drop dbo.ObjectRegression'
	DROP TABLE dbo.ObjectRegression
END
GO

CREATE TABLE dbo.ObjectRegression (
	ObjectRegressionID int IDENTITY(1,1),
	ObjectProfileAID int NOT NULL,
	ObjectProfileBID int NOT NULL,
	RecordMatchCount int,
	KeyMatchCount int,
	CONSTRAINT PK_ObjectRegression PRIMARY KEY CLUSTERED (ObjectRegressionID)
);