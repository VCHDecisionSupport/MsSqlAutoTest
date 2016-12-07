USE TestLog
GO

IF OBJECT_ID('dbo.ObjectAttributeProfile') IS NOT NULL
BEGIN
	PRINT 'drop dbo.ObjectAttributeProfile'
	DROP TABLE dbo.ObjectAttributeProfile
END
GO

CREATE TABLE dbo.ObjectAttributeProfile (
	ObjectAttributeProfileID int IDENTITY(1,1),
	ObjectProfileID int NOT NULL,
	ObjectAttributeID int NOT NULL,
	NullCount int,
	DistinctCount int,
	ZeroCount int,
	CONSTRAINT PK_ObjectAttributeProfile PRIMARY KEY CLUSTERED (ObjectAttributeProfileID)
);

