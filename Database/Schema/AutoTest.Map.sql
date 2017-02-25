USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

DECLARE @sql varchar(max);

DECLARE @name varchar(100) = 'Map'

IF SCHEMA_ID(@name) IS NULL
	SET @sql = 'CREATE SCHEMA '+@name;
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
GO