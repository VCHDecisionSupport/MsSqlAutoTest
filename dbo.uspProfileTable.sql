USE AutoTest
GO


IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspProfileTable') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspProfileTable AS');
END
GO

/****** Object:  StoredProcedure dbo.uspProfileTable   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspProfileTable
	@pDatabaseName varchar(500)
	,@pSchemaName varchar(500) = 'dbo'
	,@pTableName varchar(500) = NULL
	,@pDistinctCountLimit int = 10000
	,@pPkgExecKey int = 0
AS
BEGIN
	PRINT('dbo.uspProfileTable @pDatabaseName='''+@pDatabaseName+''', @pSchemaName='''+@pSchemaName+''', @pTableName='''+@pTableName+''', @pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+', @pPkgExecKey='+CAST(@pPkgExecKey AS varchar)+'');

	DECLARE @tableProfileTable varchar(500) = 'AutoTest.dbo.TableProfile';
	DECLARE @columnProfileTable varchar(500) = 'AutoTest.dbo.ColumnProfile';
	DECLARE @columnHistogramTable varchar(500) = 'AutoTest.dbo.ColumnHistogram';
	DECLARE @profileDate varchar(30) = CONVERT(nvarchar(30), GETDATE(), 126)
	--------------------------------------------------------------------
	-- get columns of table from uspGetColumns
	--------------------------------------------------------------------
	CREATE TABLE #temp_columns (
		schema_name varchar(500)
		,table_name varchar(500)
		,column_name varchar(500)
	);

	INSERT INTO #temp_columns
	EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName

	DECLARE @schema_name varchar(500)
		,@table_name varchar(500)
		,@column_name varchar(500)
		,@sql nvarchar(max)
		,@param nvarchar(max)
		,@distinct_count int
		,@row_count int
		,@profile_id int;

	--------------------------------------------------------------------
	-- loop over distinct tables in #temp_columns
	--------------------------------------------------------------------

	DECLARE table_cur CURSOR LOCAL
	FOR
	SELECT DISTINCT schema_name, table_name
	FROM #temp_columns;

	OPEN table_cur;

	FETCH NEXT FROM table_cur INTO 
		@schema_name
		,@table_name;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@schema_name);
		PRINT(@table_name);

		--------------------------------------------------------------------
		-- get row_count of table
		--------------------------------------------------------------------
		SET @sql = '
SELECT @row_countOUT=COUNT(*)
FROM ['+@pDatabaseName+'].['+@schema_name+'].['+@table_name+']
';
		PRINT(@sql);
		SET @param = '@row_countOUT int OUTPUT';
		EXECUTE sp_executesql @sql, @param, @row_countOUT=@row_count OUTPUT;

		PRINT('COUNT(*) = '+CAST(@distinct_count AS varchar));

		SET @sql = '
INSERT INTO '+@tableProfileTable+'(TableProfileDate,DatabaseName,SchemaName,TableName,RecordCount,PkgExecKey)
VALUES (
	CONVERT(datetime, '''+@profileDate+''' , 126)
	,'''+@pDatabaseName+'''
	,'''+@schema_name+'''
	,'''+@table_name+'''
	,'+CAST(@row_count AS varchar)+'
	,'+CAST(@pPkgExecKey AS varchar)+'
);
';
		PRINT(@sql);
	
		BEGIN TRANSACTION
			
			EXEC(@sql);
			SELECT @profile_id = MAX(ProfileID) FROM AutoTest.dbo.TableProfile;

		COMMIT
		
		--------------------------------------------------------------------
		-- loop over columns in @pDatabaseName.@schema_name.@table_name
		--------------------------------------------------------------------

		DECLARE column_table_cur CURSOR LOCAL
		FOR
		SELECT DISTINCT column_name
		FROM #temp_columns
		WHERE schema_name = @schema_name
		AND table_name = @table_name;

		OPEN column_table_cur;

		FETCH NEXT FROM column_table_cur INTO 
			@column_name;
		
		WHILE @@FETCH_STATUS = 0
		BEGIN

	--------------------------------------------------------------------
	-- check distinct count of column... skip when > @pDistinctCountLimit
	--------------------------------------------------------------------
	SET @sql = '
SELECT @distinct_countOUT=COUNT(DISTINCT ['+@column_name+'])
FROM ['+@pDatabaseName+'].['+@schema_name+'].['+@table_name+']
';
	PRINT(@sql);
	SET @param = '@distinct_countOUT int OUTPUT';
	EXECUTE sp_executesql @sql, @param, @distinct_countOUT=@distinct_count OUTPUT;

	PRINT('COUNT(DISTINCT ['+@column_name+']) = '+CAST(@distinct_count AS varchar));

	SET @sql = '-- ooga booga
INSERT INTO '+@columnProfileTable+'(ColumnProfileDate,DatabaseName,SchemaName,TableName,ColumnName,DistinctCount,PkgExecKey,ProfileID)
VALUES (
	CONVERT(datetime, '''+@profileDate+''' , 126)
	,'''+@pDatabaseName+'''
	,'''+@schema_name+'''
	,'''+@table_name+'''
	,'''+@column_name+'''
	,'+CAST(@distinct_count AS varchar)+'
	,'+CAST(@pPkgExecKey AS varchar)+'
	,'+CAST(@profile_id AS varchar)+'
);
';
	PRINT(@sql);
	EXEC(@sql);


	IF @distinct_count > @pDistinctCountLimit
	BEGIN
		PRINT('too many distinct values (@pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+')... skipping histogram for '+@column_name);
	END
	ELSE
	BEGIN
	--------------------------------------------------------------------
	-- insert dbo.ColumnHistogram group by counts for column @column_name in table @table_name
	--------------------------------------------------------------------
	SET @sql = '
INSERT INTO '+@columnHistogramTable+'
SELECT 
	CONVERT(datetime, '''+@profileDate+''' , 126)
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@schema_name+''' AS SchemaName
	,'''+@table_name+''' AS TableName
	,'''+@column_name+''' AS ColumnName
	,['+@column_name+'] AS ColumnValue
	,COUNT(*) AS ValueCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'+CAST(@profile_id AS varchar)+'
FROM ['+@pDatabaseName+'].['+@schema_name+'].['+@table_name+']
GROUP BY ['+@column_name+'];';
		PRINT(@sql);
		EXEC(@sql);
		END

		FETCH NEXT FROM column_table_cur INTO 
			@column_name;

		END -- column_table_cur loop end

		CLOSE column_table_cur;
		DEALLOCATE column_table_cur;

		FETCH NEXT FROM table_cur INTO 
			@schema_name
			,@table_name;

	END -- table_cur loop end

	CLOSE table_cur;
	DEALLOCATE table_cur;

END
GO
