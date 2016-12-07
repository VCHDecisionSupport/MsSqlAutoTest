USE DQMF

IF OBJECT_ID('dbo.RegressionTest') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.RegressionTest'
	DROP TABLE dbo.RegressionTest
END
GO

PRINT 'CREATE TABLE dbo.RegressionTest'
CREATE TABLE dbo.RegressionTest (
	RegressionTestID int IDENTITY(1,1),
	PkgExecKey int NOT NULL,
	DataRequestID int NOT NULL,
	ObjectID int NOT NULL,
	RecordMatchProfileID int,
	PreEtlObjectProfileID int,
	PostEtlObjectProfileID int,
	PreEtlKeyMatchProfileID int,
	PostEtlKeyMatchProfileID int,
	PreEtlKeyMisMatchProfileID int,
	PostEtlKeyMisMatchProfileID int
);

-- CREATE CLUSTERED INDEX PK_RegressionTest ON RegressionTest(PkgExecKey, RegressionTestID);
-- CREATE NONCLUSTERED INDEX Ix_RegressionTest_DataRequestID ON RegressionTest(DataRequestID);
-- CREATE NONCLUSTERED INDEX Ix_RegressionTest_PkgExecKey ON RegressionTest(PkgExecKey);
-- CREATE NONCLUSTERED INDEX Ix_RegressionTest_DataDefinitionID ON RegressionTest(DataDefinitionID);

USE DQMF

IF OBJECT_ID('dbo.ColumnProfile') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.ColumnProfile'
	DROP TABLE dbo.ColumnProfile
END
GO

PRINT 'CREATE TABLE dbo.ColumnProfile'
CREATE TABLE dbo.ColumnProfile (
	ColumnProfileID int IDENTITY(1,1),
	ProfileID int,
	ObjectID int,
	ColumnID int NOT NULL,
	ColumnName varchar(100) NOT NULL,
	ColumnType varchar(100) NOT NULL,
	DistinctCount int NOT NULL,
	NullCount int NOT NULL,
	ZeroCount int NOT NULL,
	BlankCount int NOT NULL
);




USE DQMF

IF OBJECT_ID('dbo.ColumnHistogram') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.ColumnHistogram'
	DROP TABLE dbo.ColumnHistogram
END
GO

PRINT 'CREATE TABLE dbo.ColumnHistogram'
CREATE TABLE dbo.ColumnHistogram (
	ColumnHistogramID int IDENTITY(1,1),
	ColumnProfileID int NOT NULL,
	ColumnValue nvarchar(100)
);


USE DQMF

IF OBJECT_ID('dbo.ColumnRegression') IS NOT NULL
BEGIN
	PRINT 'DROP dbo.ColumnRegression'
	DROP TABLE dbo.ColumnRegression
END
GO

PRINT 'CREATE TABLE dbo.ColumnRegression'
CREATE TABLE dbo.ColumnRegression (
	ColumnRegressionID int IDENTITY(1,1),
	RegressionTestID int NOT NULL,
	ColumnID int NOT NULL,
	ColumnName varchar(100) NOT NULL,
	ColumnType varchar(100) NOT NULL,
	ColumnValue nvarchar(100),
	ColumnValueMatchCount int
);
