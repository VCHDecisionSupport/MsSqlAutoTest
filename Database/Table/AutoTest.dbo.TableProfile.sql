USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

DECLARE @sql varchar(max);

DECLARE @name varchar(100) = 'dbo.TableProfile'
RAISERROR(@name,0,1) WITH NOWAIT;

IF OBJECT_ID(@name) IS NOT NULL
	SET @sql = 'DROP TABLE '+@name;
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
GO

CREATE TABLE dbo.TableProfile
(
	TableProfileDate smalldatetime
	,DatabaseName varchar(500)
	,TableName varchar(500)
	,SchemaName varchar(500)
	,RecordCount int
	,PackageName varchar(500)
	,PkgExecKey int
	,ProfileID int IDENTITY(1,1)
);
GO