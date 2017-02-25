USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetTables') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetTables AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetTables
	@pDatabaseName varchar(500)
	,@pSchemaName varchar(500) = ''
AS
BEGIN 
	PRINT 'dbo.uspGetTables @pDatabaseName='''+@pDatabaseName+''', @pSchemaName='''+@pSchemaName+'''';
	DECLARE @sql varchar(max);
	DECLARE @params varchar(max);

	SELECT @sql = 
		CASE WHEN @pSchemaName != '' THEN
'SELECT DISTINCT
	sch.name AS schema_name
	,tab.name AS table_name
FROM '+@pDatabaseName+'.sys.tables AS tab
JOIN '+@pDatabaseName+'.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
WHERE 1=1
AND sch.name = '''+@pSchemaName+'''
ORDER BY sch.name, tab.name;'
ELSE
'SELECT DISTINCT
	sch.name AS schema_name
	,tab.name AS table_name
FROM '+@pDatabaseName+'.sys.tables AS tab
JOIN '+@pDatabaseName+'.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
WHERE 1=1
ORDER BY sch.name, tab.name;'
END
	EXEC(@sql);
END
GO

