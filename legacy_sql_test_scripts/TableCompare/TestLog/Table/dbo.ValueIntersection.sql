PRINT '
	executing dbo.ValueIntersection.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.ValueIntersection', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.ValueIntersection exists... DROP';
	DROP TABLE dbo.ValueIntersection;
END
GO

CREATE TABLE dbo.ValueIntersection
(
	ValueIntersectionID int IDENTITY(1,1), -- pk
	QueryIntersectionID int NOT NULL, -- fk to QueryIntersection table
	DistinctCount int NOT NULL, -- number of distinct keys present in both queries corresponding to rows  
	CONSTRAINT PK_ValueIntersection PRIMARY KEY CLUSTERED (ValueIntersectionID)
)
GO