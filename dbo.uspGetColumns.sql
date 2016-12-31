USE AutoTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetColumns') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetColumns AS');
END
GO

/****** Object:  StoredProcedure dbo.uspGetTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetColumns
	@pDatabaseName varchar(500)
	,@pSchemaName varchar(500) = ''
	,@pTableName varchar(500) = ''
AS
BEGIN 
	PRINT 'dbo.uspGetColumns @pDatabaseName='''+@pDatabaseName+''', @pSchemaName='''+@pSchemaName+''', @pTableName='''+@pTableName+'''';
	DECLARE @sql varchar(max);
	DECLARE @params varchar(max);

	SET @sql = 
'
SELECT 
	sch.name AS schema_name
	,tab.name AS table_name
	,col.name AS column_name
FROM '+@pDatabaseName+'.sys.tables AS tab
JOIN '+@pDatabaseName+'.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
JOIN '+@pDatabaseName+'.sys.columns AS col
ON col.object_id = tab.object_id
WHERE 1=1
'
	IF @pTableName != ''
	BEGIN 
		SET @sql = @sql + 
'AND tab.name = '''+@pTableName+'''
'
	END

	IF @pSchemaName != ''
	BEGIN 
		SET @sql = @sql + 
'AND sch.name = '''+@pSchemaName+'''
'
	END

SET @sql = @sql + 
'ORDER BY sch.name, tab.name, col.column_id;
'
	PRINT(@sql)
	EXEC(@sql);
END
GO


