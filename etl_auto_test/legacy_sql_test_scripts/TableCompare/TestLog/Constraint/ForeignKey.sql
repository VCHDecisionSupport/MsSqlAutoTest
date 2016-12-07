PRINT '
	executing ForeignKey.sql'

USE TestLog
GO

DECLARE @sql varchar(max) = '';

SELECT @sql = @sql + '
 ALTER TABLE ' + OBJECT_NAME(fk.parent_object_id) + ' DROP CONSTRAINT '+ fk.name + ';'
FROM sys.foreign_keys AS fk;

PRINT @sql;
EXEC(@sql);


ALTER TABLE dbo.ValueColumn ADD CONSTRAINT FK_ValueComparisonID_ValueColumn FOREIGN KEY (ValueComparisonID) REFERENCES ValueComparison(ValueComparisonID);
ALTER TABLE dbo.ValueComparison ADD CONSTRAINT FK_KeyComparisonID FOREIGN KEY (KeyComparisonID) REFERENCES KeyComparison(KeyComparisonID);
ALTER TABLE dbo.KeyColumn ADD CONSTRAINT FK_KeyComparisonID_KeyColumn FOREIGN KEY (KeyComparisonID) REFERENCES KeyComparison(KeyComparisonID);
GO
PRINT '
execution complete'