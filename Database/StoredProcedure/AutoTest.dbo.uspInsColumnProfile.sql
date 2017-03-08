
USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspInsColumnProfile') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspInsColumnProfile AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspInsColumnProfile
	@columnProfileTable VARCHAR(500) = 'AutoTest.dbo.ColumnProfile'
	,@pProfileDateIsoStr VARCHAR(33) -- YYYY-MM-DDThh:mm:ss.??? eg. 2017-03-02T14:46:55.113
	,@pDatabaseName  VARCHAR(500)
	,@pSchemaName  VARCHAR(500)
    ,@pTableName  VARCHAR(500)
    ,@pColumnName  VARCHAR(500)
	,@pColumnDataType  VARCHAR(500)
	,@pDistinctRowCount int
    ,@pPkgExecKey int
	,@pProfileId int
AS
BEGIN
	PRINT('dbo.uspInsColumnProfile @pDatabaseName='+@pDatabaseName+', @pSchemaName = '+@pSchemaName+', @pTableName = '+@pTableName+', @pColumnName = '+@pColumnName+', @pDistinctRowCount = '+CAST(@pDistinctRowCount AS varchar)+';')
	DECLARE @sql VARCHAR(MAX);
        SET @sql = '-- ooga booga
INSERT INTO '+@columnProfileTable+'(ColumnProfileDate,DatabaseName,SchemaName,TableName,ColumnName,DataType,DistinctCount,PkgExecKey,ProfileID)
SELECT
    CONVERT(datetime, '''+@pProfileDateIsoStr+''' , 126) AS ColumnProfileDate
    ,CAST('''+@pDatabaseName+''' AS varchar(500)) AS DatabaseName
    ,CAST('''+@pSchemaName+''' AS varchar(500)) AS SchemaName
    ,CAST('''+@pTableName+''' AS varchar(500)) AS TableName
    ,CAST('''+@pColumnName+''' AS varchar(500)) AS ColumnName
    ,CAST('''+@pColumnDataType+''' AS varchar(500)) AS DataType
    ,'+CAST(@pDistinctRowCount AS varchar)+' AS DistinctCount
    ,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
    ,'+CAST(@pProfileId AS varchar)+' AS ProfileID;'
	EXEC(@sql);
END
GO
