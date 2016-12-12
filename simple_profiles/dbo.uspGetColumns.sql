USE gcTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetColumns') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetColumns AS');
END
GO

/****** Object:  StoredProcedure dbo.uspuspGetTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetColumns
	@pDatabaseName varchar(500)
	,@pTableName varchar(500) = NULL
AS
BEGIN 
	PRINT 'dbo.uspGetColumns(@pDatabaseName='+@pDatabaseName+', @pTableName='+@pTableName+')';
	DECLARE @sql varchar(max);
	DECLARE @params varchar(max);

	SELECT @sql = 
		CASE WHEN @pTableName IS NOT NULL THEN
'SELECT 
	sch.name AS schema_name
	,tab.name AS table_name
	,col.name AS column_name
FROM '+@pDatabaseName+'.sys.tables AS tab
JOIN '+@pDatabaseName+'.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
JOIN '+@pDatabaseName+'.sys.columns AS col
ON col.object_id = tab.object_id
WHERE 1=1
AND tab.name = '''+@pTableName+'''
ORDER BY sch.name, tab.name, col.column_id;'
ELSE
'SELECT 
	sch.name AS schema_name
	,tab.name AS table_name
	,col.name AS column_name
FROM '+@pDatabaseName+'.sys.tables AS tab
JOIN '+@pDatabaseName+'.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
JOIN '+@pDatabaseName+'.sys.columns AS col
ON col.object_id = tab.object_id
WHERE 1=1
ORDER BY sch.name, tab.name, col.column_id;'
END
	EXEC(@sql);
END
GO

DROP TABLE #temp;

CREATE TABLE #temp (
	schema_name varchar(500)
	,table_name varchar(500)
	,column_name varchar(500)
);

--INSERT INTO #temp
--EXEC dbo.uspGetColumns @pDatabaseName='CommunityMart'

INSERT INTO #temp
EXEC dbo.uspGetColumns @pDatabaseName='CommunityMart', @pTableName='ReferralFact'

SELECT *
FROM #temp;