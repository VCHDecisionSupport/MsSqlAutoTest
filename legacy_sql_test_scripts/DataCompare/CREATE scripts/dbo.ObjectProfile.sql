USE TestLog
GO

IF OBJECT_ID('dbo.ObjectProfile') IS NOT NULL
BEGIN
	PRINT 'drop dbo.ObjectProfile'
	DROP TABLE dbo.ObjectProfile
END
GO

CREATE TABLE dbo.ObjectProfile (
	ObjectProfileID int IDENTITY(1,1),
	ObjectID int NOT NULL,
	PkgExecKey int,
	DataRequestID int NOT NULL,
	RecordCount int,
	ObjectProfileDate datetime,
	CONSTRAINT PK_ObjectProfile PRIMARY KEY CLUSTERED (ObjectProfileID)
);