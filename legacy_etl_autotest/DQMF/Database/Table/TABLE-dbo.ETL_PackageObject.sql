USE DQMF
GO

IF OBJECT_ID('dbo.ETL_PackageObject') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.ETL_PackageObject'
	DROP TABLE dbo.ETL_PackageObject
END
GO

PRINT 'CREATE TABLE dbo.ETL_PackageObject'
CREATE TABLE dbo.ETL_PackageObject (
	PackageID int NOT NULL
	,ObjectID int NOT NULL
	,TestTypeID int NULL
	,UpdateDate datetime NULL
);
