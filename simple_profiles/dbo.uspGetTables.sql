USE gcTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetTables') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetTables AS');
END
GO

/****** Object:  StoredProcedure dbo.uspuspGetTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetTables
	@pDatabaseName varchar(500)
AS
BEGIN 
	PRINT 'dbo.uspGetTables';
	DECLARE @sql varchar(max);
	DECLARE @params varchar(max);

	SET @sql = 'SELECT 
		sch.name AS schema_name
		,tab.name AS table_name
	FROM '+@pDatabaseName+'.sys.tables AS tab
	JOIN '+@pDatabaseName+'.sys.schemas AS sch
	ON tab.schema_id = sch.schema_id
	WHERE 1=1
	ORDER BY sch.name, tab.name;'

	EXEC(@sql);
END
GO

DROP TABLE #temp;

CREATE TABLE #temp (
	schema_name varchar(500)
	,table_name varchar(500)
);
INSERT INTO #temp
EXEC dbo.uspGetTables @pDatabaseName='CommunityMart'

SELECT *
FROM #temp;