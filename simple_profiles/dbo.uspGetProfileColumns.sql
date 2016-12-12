USE gcTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetProfileColumns') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetProfileColumns AS');
END
GO

/****** Object:  StoredProcedure dbo.uspuspGetTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetProfileColumns
	@pDatabaseName varchar(500)
	,@pTableName varchar(500) = NULL
AS
BEGIN 
	PRINT 'dbo.uspGetProfileColumns(@pDatabaseName='+@pDatabaseName+', @pTableName='+@pTableName+')';

	EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pTableName=@pTableName
END
GO

DROP TABLE #temp;

CREATE TABLE #temp (
	schema_name varchar(500)
	,table_name varchar(500)
	,column_name varchar(500)
);

--INSERT INTO #temp
--EXEC dbo.uspGetProfileColumns @pDatabaseName='CommunityMart'

INSERT INTO #temp
EXEC dbo.uspGetProfileColumns @pDatabaseName='CommunityMart', @pTableName='ReferralFact'

SELECT *
FROM #temp;