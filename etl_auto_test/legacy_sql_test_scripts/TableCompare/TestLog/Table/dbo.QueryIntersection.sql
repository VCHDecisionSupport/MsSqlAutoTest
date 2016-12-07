PRINT '
	executing dbo.QueryIntersection.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.QueryIntersection', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.QueryIntersection exists... DROP';
	DROP TABLE dbo.QueryIntersection;
END
GO

CREATE TABLE dbo.QueryIntersection
(
	QueryIntersectionID int IDENTITY(1,1), -- pk for this table
	DistinctCount int NOT NULL, -- number of distinct keys present in both query
	SUserLogin varchar(200), -- user that executed comparison proc 
	ComparisonDate date, -- date that comparison proc was executed
	CONSTRAINT PK_QueryIntersection PRIMARY KEY CLUSTERED (QueryIntersectionID)
)
GO