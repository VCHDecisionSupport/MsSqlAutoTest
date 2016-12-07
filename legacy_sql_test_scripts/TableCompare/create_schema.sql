-- =========================================
-- Create table template
-- =========================================
USE master
GO

IF DB_ID('TestLog') IS NULL
BEGIN 
	PRINT 'TestLog database does not exist'
	DECLARE @sql nvarchar(128);
	SET @sql = 'CREATE DATABASE TestLog;'
	EXEC(@sql);
END
GO
USE TestLog
GO
IF OBJECT_ID('dbo.ValueColumn', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.ValueColumn exists... DROP';
	DROP TABLE dbo.ValueColumn;
END
GO
IF OBJECT_ID('dbo.ValueComparison', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.ValueComparison exists... DROP'
	DROP TABLE dbo.ValueComparison;
END
GO
IF OBJECT_ID('dbo.KeyColumn', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.KeyColumn exists... DROP'
	DROP TABLE dbo.KeyColumn;
END
GO
IF OBJECT_ID('dbo.KeyComparison', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.KeyComparison does not exist... DROP'
	DROP TABLE dbo.KeyComparison;
END
GO

CREATE TABLE dbo.ValueColumn
(
	ValueColumnID int IDENTITY(1,1), 
	ValueComparisonID int NOT NULL, 
	ColumnName nvarchar(128) NOT NULL, 
	ColumnType nvarchar(128) NOT NULL, 
	SetDifferenceCount int NOT NULL, 
	KeyMatchedNullCount int NOT NULL,
	KeyMatchedDistinctCount int NOT NULL,
	FullNullCount int NOT NULL,
	FullDistinctCount int NOT NULL,
	CONSTRAINT PK_ValueColumn PRIMARY KEY CLUSTERED (ValueColumnID)
)
GO
CREATE TABLE dbo.ValueComparison
(
	ValueComparisonID int IDENTITY(1,1), 
	KeyComparisonID int NOT NULL, 
	IntersectionCount int NOT NULL, 
	CONSTRAINT PK_ValueComparison PRIMARY KEY CLUSTERED (ValueComparisonID)
)
GO
CREATE TABLE dbo.KeyColumn
(
	KeyColumnID int IDENTITY(1,1), 
	KeyComparisonID int NOT NULL, 
	KeyColumnName nvarchar(128) NOT NULL, 
	KeyColumnType nvarchar(128) NOT NULL, 
	SetDifferenceCount int NOT NULL, 
	DuplicateCount int NOT NULL,
	DistinctCount int NOT NULL,
	KeyColumnDatabaseName nvarchar(128) NOT NULL, 
	KeyColumnSchemaName nvarchar(128) NOT NULL, 
	KeyColumnTableName nvarchar(128) NOT NULL, 
	object_id int NOT NULL,
	CONSTRAINT PK_KeyColumn PRIMARY KEY CLUSTERED (KeyColumnID)
)
GO

CREATE TABLE dbo.KeyComparison
(
	KeyComparisonID int IDENTITY(1,1), 
	IntersectionCount int NOT NULL,
	SUserLogin varchar(200),
	ComparisonDate date,
	CONSTRAINT PK_KeyComparison PRIMARY KEY CLUSTERED (KeyComparisonID)
)
GO


ALTER TABLE dbo.ValueColumn ADD CONSTRAINT FK_ValueComparisonID_ValueColumn FOREIGN KEY (ValueComparisonID) REFERENCES ValueComparison(ValueComparisonID);
ALTER TABLE dbo.ValueComparison ADD CONSTRAINT FK_KeyComparisonID FOREIGN KEY (KeyComparisonID) REFERENCES KeyComparison(KeyComparisonID);
ALTER TABLE dbo.KeyColumn ADD CONSTRAINT FK_KeyComparisonID_KeyColumn FOREIGN KEY (KeyComparisonID) REFERENCES KeyComparison(KeyComparisonID);
GO
