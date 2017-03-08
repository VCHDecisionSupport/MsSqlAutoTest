
USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspInsTableProfile') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspInsTableProfile AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspInsTableProfile
	@tableProfileTable VARCHAR(500) = 'AutoTest.dbo.TableProfile'
	,@pProfileDateIsoStr VARCHAR(33) -- YYYY-MM-DDThh:mm:ss.??? eg. 2017-03-02T14:46:55.113
	,@pPackageName  VARCHAR(500)
	,@pDatabaseName  VARCHAR(500)
	,@pSchemaName  VARCHAR(500)
	,@pTableName  VARCHAR(500)
	,@pRowCount int
	,@pPkgExecKey int
AS
BEGIN
	PRINT('dbo.uspInsTableProfile @pDatabaseName='+@pDatabaseName+', @pSchemaName = '+@pSchemaName+', @pTableName = '+@pTableName+', @pRowCount = '+CAST(@pRowCount AS varchar)+';')
	DECLARE @sql VARCHAR(MAX);
	SET @sql = '
	INSERT INTO '+@tableProfileTable+'(TableProfileDate,DatabaseName,SchemaName,TableName,RecordCount,PkgExecKey,PackageName)
	SELECT
		CONVERT(datetime, '''+@pProfileDateIsoStr+''' , 126) AS TableProfileDate
		,'''+@pDatabaseName+''' AS DatabaseName
		,'''+@pSchemaName+''' AS SchemaName
		,'''+@pTableName+''' AS TableName
		,'+CAST(@pRowCount AS varchar)+' AS RecordCount
		,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
		,'''+@pPackageName+''' AS PackageName;
	';
	EXEC(@sql);
END
GO
