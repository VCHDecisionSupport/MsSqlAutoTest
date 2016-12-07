PRINT '
	executing dbo.KeyColumn.sql'


USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);

IF OBJECT_ID('dbo.KeyColumn', 'U') IS NOT NULL
BEGIN
	PRINT 'TABLE dbo.KeyColumn exists... DROP';
	DROP TABLE dbo.KeyColumn;
END
GO

CREATE TABLE dbo.KeyColumn
(
	KeyColumnID int IDENTITY(1,1), -- pk of this table
	QueryDefinitionID int NOT NULL, -- fk to QueryDifference table
	ColumnName nvarchar(128) NOT NULL, -- column name of this key column
	CONSTRAINT PK_KeyColumn PRIMARY KEY CLUSTERED (KeyColumnID)
)
GO