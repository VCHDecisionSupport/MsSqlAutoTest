USE AutoTest
GO


IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspProfilePackageTables') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspProfilePackageTables AS');
END
GO

/****** Object:  StoredProcedure dbo.uspProfilePackageTables   DR0000 Graham Crowell 2016-01-00 ******/
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
	PRINT('dbo.uspProfilePackageTables @pPackageName='''+@pPackageName+''', @pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+', @pPkgExecKey='+CAST(@pPkgExecKey AS varchar)+'');

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
	AND PackageName = @pPackageName;

	OPEN table_cur;

	FETCH NEXT FROM table_cur INTO 
		@database_name
		,@schema_name
		,@table_name;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@database_name);
		PRINT(@schema_name);
		PRINT(@table_name);

		EXEC dbo.uspProfileTable @pDatabaseName=@database_name, @pSchemaName=@schema_name, @pTableName=@table_name, @pDistinctCountLimit=@pDistinctCountLimit, @pPkgExecKey=@pPkgExecKey
		
		FETCH NEXT FROM table_cur INTO 
			@database_name
			,@schema_name
			,@table_name;
	END -- table_cur loop end

	CLOSE table_cur;
	DEALLOCATE table_cur;

END
GO
