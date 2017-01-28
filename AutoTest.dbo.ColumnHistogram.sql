USE AutoTest
GO

DECLARE @sql varchar(max);

DECLARE @name varchar(100) = 'dbo.ColumnHistogram'
RAISERROR(@name,0,1) WITH NOWAIT;

IF OBJECT_ID(@name) IS NOT NULL
	SET @sql = 'DROP TABLE '+@name;
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
GO

CREATE TABLE dbo.ColumnHistogram
(
	ColumnHistogramDate smalldatetime
	,DatabaseName varchar(500)
	,SchemaName varchar(500)
	,TableName varchar(500)
	,ColumnName varchar(500)
	,ColumnValue varchar(500)
	,ValueCount int
	,PkgExecKey int
	,ProfileID int
);
GO

