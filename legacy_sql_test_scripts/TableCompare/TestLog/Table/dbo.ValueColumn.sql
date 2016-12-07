PRINT '
	executing dbo.ValueColumn.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.ValueColumn', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.ValueColumn exists... DROP';
	DROP TABLE dbo.ValueColumn;
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