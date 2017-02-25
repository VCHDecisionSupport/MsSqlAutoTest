USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspProfilePackageTables') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspProfilePackageTables AS');
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspProfilePackageTables
	@pPackageName varchar(500)
	,@pDistinctCountLimit int = 10000
	,@pPkgExecKey int = 0
AS
BEGIN
	SELECT 'dbo.uspProfilePackageTables @pPackageName='''+@pPackageName+''', @pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+', @pPkgExecKey='+CAST(@pPkgExecKey AS varchar)+'' AS [AutoTest profiling proc];
	PRINT(CHAR(10)+'dbo.uspProfilePackageTables @pPackageName='''+@pPackageName+''', @pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+', @pPkgExecKey='+CAST(@pPkgExecKey AS varchar)+'');

	DECLARE 
		@database_name varchar(500)
		,@schema_name varchar(500)
		,@table_name varchar(500);

	--------------------------------------------------------------------
	-- loop over distinct @pPackageName tables in AutoTest.Map.PackageTable ()
	--------------------------------------------------------------------

	DECLARE table_cur CURSOR LOCAL
	FOR
	SELECT DISTINCT
		DatabaseName
		,SchemaName
		,TableName
	FROM AutoTest.Map.PackageTable
	WHERE 1=1
	AND IsProfilingOn = 1
	AND PackageName = @pPackageName;

	OPEN table_cur;

	FETCH NEXT FROM table_cur INTO 
		@database_name
		,@schema_name
		,@table_name;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- PRINT(@database_name+'.'+@schema_name+'.'+@table_name);
		SELECT @database_name AS DatabaseName
			,@schema_name AS SchemaName
			,@table_name AS TableName;
		EXEC dbo.uspProfileTable @pDatabaseName=@database_name, @pSchemaName=@schema_name, @pTableName=@table_name, @pDistinctCountLimit=@pDistinctCountLimit, @pPkgExecKey=@pPkgExecKey, @pPackageName=@pPackageName
		
		FETCH NEXT FROM table_cur INTO 
			@database_name
			,@schema_name
			,@table_name;
	END -- table_cur loop end

	CLOSE table_cur;
	DEALLOCATE table_cur;

END
GO
