USE gcTest
GO

DECLARE @sql varchar(max);

DECLARE @name varchar(100) = 'Map.PackageTable'
RAISERROR(@name,0,1) WITH NOWAIT;

IF OBJECT_ID(@name) IS NOT NULL
	SET @sql = 'DROP TABLE '+@name;
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
GO

CREATE TABLE Map.PackageTable
(
	PackageName varchar(500)
	,DatabaseName varchar(500)
	,TableName varchar(500)
);