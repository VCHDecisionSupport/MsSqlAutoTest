PRINT '
	executing dbo.KeyComparison.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.KeyComparison', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.KeyComparison exists... DROP';
	DROP TABLE dbo.KeyComparison;
END
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