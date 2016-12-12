USE gcTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetProfileTables') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetProfileTables AS');
END
GO

/****** Object:  StoredProcedure dbo.uspuspGetProfileTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspGetProfileTables
	@pDatabaseName varchar(500)
AS
BEGIN 
	PRINT 'dbo.uspGetProfileTables';
	EXEC dbo.uspGetTables @pDatabaseName=@pDatabaseName
END
GO

DROP TABLE #temp;

CREATE TABLE #temp (
	schema_name varchar(500)
	,table_name varchar(500)
);
INSERT INTO #temp
EXEC dbo.uspGetProfileTables @pDatabaseName='CommunityMart'

SELECT *
FROM #temp;