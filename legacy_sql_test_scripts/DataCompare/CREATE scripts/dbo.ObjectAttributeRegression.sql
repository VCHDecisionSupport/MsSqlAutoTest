USE TestLog
GO

IF OBJECT_ID('dbo.ObjectAttributeRegression') IS NOT NULL
BEGIN
	PRINT 'drop dbo.ObjectAttributeRegression'
	DROP TABLE dbo.ObjectAttributeRegression
END
GO

CREATE TABLE dbo.ObjectAttributeRegression (
	ObjectAttributeRegressionID int IDENTITY(1,1),
	ObjectAttributeProfileAID int NOT NULL,
	ObjectAttributeProfileBID int NOT NULL,
	ObjectAttributeMatchCount int,
	CONSTRAINT PK_ObjectAttributeRegression PRIMARY KEY CLUSTERED (ObjectAttributeRegressionID)
);