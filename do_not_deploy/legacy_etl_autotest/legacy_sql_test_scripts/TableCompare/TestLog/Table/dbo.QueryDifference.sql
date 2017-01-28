PRINT '
	executing dbo.QueryDifference.sql'


USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.QueryDifference', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.QueryDifference exists... DROP';
	DROP TABLE dbo.QueryDifference;
END
GO

CREATE TABLE dbo.QueryDifference
(
	QueryDifferenceID int IDENTITY(1,1), -- pk of this table
	QueryCompareID int NOT NULL, -- fk to QueryIntersection table
	QuerySql varchar(MAX), -- sql to create view of query
	KeyDifferenceCount int NOT NULL, -- total number of rows with a key not present in other query
	KeyDuplicateCount int NOT NULL, -- total number of rows with a non-unique key
	DistinctCount int NOT NULL, -- total number of rows with a unique key
	CONSTRAINT PK_QueryDifference PRIMARY KEY CLUSTERED (QueryDifferenceID)
)
GO