PRINT '
	executing dbo.ValueComparison.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.ValueComparison', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.ValueComparison exists... DROP';
	DROP TABLE dbo.ValueComparison;
END
GO

CREATE TABLE dbo.ValueComparison
(
	ValueComparisonID int IDENTITY(1,1), 
	KeyComparisonID int NOT NULL, 
	IntersectionCount int NOT NULL, 
	CONSTRAINT PK_ValueComparison PRIMARY KEY CLUSTERED (ValueComparisonID)
)
GO