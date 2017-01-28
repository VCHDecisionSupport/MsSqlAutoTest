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
	,@pPackageName varchar(500) = ''
	,@pLogResults bit = 1
AS
BEGIN
	PRINT('dbo.uspProfileTable @pDatabaseName='''+@pDatabaseName+''', @pSchemaName='''+@pSchemaName+''', @pTableName='''+@pTableName+''', @pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+', @pPkgExecKey='+CAST(@pPkgExecKey AS varchar)+', @pPackageName='+CAST(@pPackageName AS varchar)+'');

	DECLARE @profileDate varchar(30) = CONVERT(nvarchar(30), GETDATE(), 126)
	DECLARE @schema_name varchar(500)
		,@table_name varchar(500)
		,@column_name varchar(500)
		,@data_type varchar(500)
		,@sql nvarchar(max)
		,@param nvarchar(max)
		,@distinct_count int
		,@row_count int
		,@profile_id int
		,@isFirstColumn bit = 1
		,@tableProfileTable varchar(500)
		,@columnProfileTable varchar(500)
		,@columnHistogramTable varchar(500)


	--------------------------------------------------------------------
	-- when @pLogResults = 0 AND @isFirstColumn = 0 (first iteration of column loop) temp tables are created by replacing SELECT INTO with INSERT INTO
	--------------------------------------------------------------------

	IF @pLogResults = 1
	BEGIN
		SET @tableProfileTable = 'AutoTest.dbo.TableProfile';
		SET @columnProfileTable = 'AutoTest.dbo.ColumnProfile';
		SET @columnHistogramTable = 'AutoTest.dbo.ColumnHistogram';
	END
	ELSE
	BEGIN
		SET @tableProfileTable = '##TableProfile' + SUBSTRING(CAST(NEWID() AS varchar(36)),0,7);
		PRINT(@tableProfileTable)
		SET @columnProfileTable = '##ColumnProfile' + SUBSTRING(CAST(NEWID() AS varchar(36)),0,7);
		PRINT(@columnProfileTable)
		SET @columnHistogramTable = '##ColumnHistogram' + SUBSTRING(CAST(NEWID() AS varchar(36)),0,7);
		PRINT(@columnHistogramTable)
		BEGIN TRANSACTION
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @tableProfileTable)
				EXEC('DROP TABLE '+@TableProfileTable);
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @columnProfileTable)
				EXEC('DROP TABLE '+@ColumnProfileTable);
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @columnHistogramTable)
				EXEC('DROP TABLE '+@ColumnHistogramTable);
		COMMIT
	END
	--------------------------------------------------------------------
	-- get columns of table from uspGetColumns
	--------------------------------------------------------------------
	CREATE TABLE #temp_columns (
		schema_name varchar(500)
		,table_name varchar(500)
		,column_name varchar(500)
		,data_type varchar(500)
	);

	INSERT INTO #temp_columns
	EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName

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

		IF @pLogResults = 1
		BEGIN

			SET @sql = '
INSERT INTO '+@tableProfileTable+'(TableProfileDate,DatabaseName,SchemaName,TableName,RecordCount,PkgExecKey,PackageName)
SELECT
	CONVERT(datetime, '''+@profileDate+''' , 126) AS TableProfileDate
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@schema_name+''' AS SchemaName
	,'''+@table_name+''' AS TableName
	,'+CAST(@row_count AS varchar)+' AS RecordCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'''+@pPackageName+''' AS PackageName;
';
		END

		ELSE
		BEGIN
			SET @sql = '
SELECT
	CONVERT(datetime, '''+@profileDate+''' , 126) AS TableProfileDate
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@schema_name+''' AS SchemaName
	,'''+@table_name+''' AS TableName
	,'+CAST(@row_count AS varchar)+' AS RecordCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'''+@pPackageName+''' AS PackageName
INTO '+@tableProfileTable+';';
		END

	
		BEGIN TRANSACTION
			PRINT(@sql);
			EXEC(@sql);
			SELECT @profile_id = MAX(ProfileID) FROM AutoTest.dbo.TableProfile;
		COMMIT
		
		--------------------------------------------------------------------
		-- loop over columns in @pDatabaseName.@schema_name.@table_name
		--------------------------------------------------------------------

		DECLARE column_table_cur CURSOR LOCAL
		FOR
		SELECT DISTINCT 
			column_name
			,data_type
		FROM #temp_columns
		WHERE schema_name = @schema_name
		AND table_name = @table_name;

		OPEN column_table_cur;

		FETCH NEXT FROM column_table_cur INTO 
			@column_name
			,@data_type
		
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
	
	--------------------------------------------------------------------
	-- when @pLogResults = 0 AND @isFirstColumn = 0 (first iteration of column loop) temp tables are created by replacing SELECT INTO with INSERT INTO
	--------------------------------------------------------------------
	IF @pLogResults = 0 AND @isFirstColumn = 1
	BEGIN
		SET @sql = '-- ooga booga
SELECT
	CONVERT(datetime, '''+@profileDate+''' , 126) AS ColumnProfileDate
	,CAST('''+@pDatabaseName+''' AS varchar(500)) AS DatabaseName
	,CAST('''+@schema_name+''' AS varchar(500)) AS SchemaName
	,CAST('''+@table_name+''' AS varchar(500)) AS TableName
	,CAST('''+@column_name+''' AS varchar(500)) AS ColumnName
	,CAST('''+@data_type+''' AS varchar(500)) AS DataType
	,'+CAST(@distinct_count AS varchar)+' AS DistinctCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'+CAST(@profile_id AS varchar)+' AS ProfileID
INTO '+@columnProfileTable+';';
	END
	ELSE -- @columnProfileTable table exists
	BEGIN
		SET @sql = '-- ooga booga
INSERT INTO '+@columnProfileTable+'(ColumnProfileDate,DatabaseName,SchemaName,TableName,ColumnName,DataType,DistinctCount,PkgExecKey,ProfileID)
SELECT
	CONVERT(datetime, '''+@profileDate+''' , 126) AS ColumnProfileDate
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@schema_name+''' AS SchemaName
	,'''+@table_name+''' AS TableName
	,'''+@column_name+''' AS ColumnName
	,'''+@data_type+''' AS DataType
	,'+CAST(@distinct_count AS varchar)+' AS DistinctCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'+CAST(@profile_id AS varchar)+' AS ProfileID;
';
	END
	-- PRINT('-----------------------------------------------------------------------------------')
	-- PRINT('@columnProfileTable = '+CAST(@columnProfileTable AS varchar(500)))
	-- PRINT('@profileDate = '+CAST(@profileDate AS varchar(500)))
	-- PRINT('@pDatabaseName = '+CAST(@pDatabaseName AS varchar(500)))
	-- PRINT('@schema_name = '+CAST(@schema_name AS varchar(500)))
	-- PRINT('@table_name = '+CAST(@table_name AS varchar(500)))
	-- PRINT('@column_name = '+CAST(@column_name AS varchar(500)))
	-- PRINT('@data_type = '+CAST(@data_type AS varchar(500)))
	-- PRINT('@distinct_count = '+CAST(@distinct_count AS varchar(500)))
	-- PRINT('@pPkgExecKey = '+CAST(@pPkgExecKey AS varchar(500)))
	-- PRINT('@profile_id = '+CAST(@profile_id AS varchar(500)))
	-- PRINT('-----------------------------------------------------------------------------------')

	BEGIN TRANSACTION
		PRINT(@sql);
		EXEC(@sql);
		SELECT @profile_id = MAX(ProfileID) FROM AutoTest.dbo.TableProfile;
	COMMIT


	IF @distinct_count > @pDistinctCountLimit
	BEGIN
		PRINT('too many distinct values (@pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+')... skipping histogram for '+@column_name);
	END
	ELSE
	BEGIN
	--------------------------------------------------------------------
	-- insert group by counts for column @column_name from table @table_name into @columnHistogramTable
	-- when @pLogResults = 0 AND @isFirstColumn = 1 (first iteration of column loop) temp tables are created by replacing SELECT INTO with INSERT INTO
	--------------------------------------------------------------------
	IF @pLogResults = 0 AND @isFirstColumn = 1
	BEGIN
		SET @sql = '
SELECT 
	CONVERT(datetime, '''+@profileDate+''' , 126) AS ColumnHistogramDate
	,CAST('''+@pDatabaseName+''' AS varchar(500)) AS DatabaseName
	,CAST('''+@schema_name+''' AS varchar(500)) AS SchemaName
	,CAST('''+@table_name+''' AS varchar(500)) AS TableName
	,CAST('''+@column_name+''' AS varchar(500)) AS ColumnName
	,CAST(['+@column_name+'] AS varchar(500)) AS ColumnValue
	,COUNT(*) AS ValueCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'+CAST(@profile_id AS varchar)+' AS ProfileID
INTO '+@columnHistogramTable+'
FROM ['+@pDatabaseName+'].['+@schema_name+'].['+@table_name+']
GROUP BY ['+@column_name+'];';
		END
	ELSE -- @columnHistogramTable table exists
		BEGIN
			SET @sql = '
INSERT INTO '+@columnHistogramTable+'(ColumnHistogramDate,DatabaseName,SchemaName,TableName,ColumnName,ColumnValue,ValueCount,PkgExecKey,ProfileID)
SELECT 
	CONVERT(datetime, '''+@profileDate+''' , 126) AS ColumnHistogramDate
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@schema_name+''' AS SchemaName
	,'''+@table_name+''' AS TableName
	,'''+@column_name+''' AS ColumnName
	,['+@column_name+'] AS ColumnValue
	,COUNT(*) AS ValueCount
	,'+CAST(@pPkgExecKey AS varchar)+' AS PkgExecKey
	,'+CAST(@profile_id AS varchar)+' AS ProfileID
FROM ['+@pDatabaseName+'].['+@schema_name+'].['+@table_name+']
GROUP BY ['+@column_name+'];';
		END -- @pLogResults = 1

	BEGIN TRANSACTION
		PRINT(@sql);
		EXEC(@sql);
	COMMIT

		END -- @distinct_count > @pDistinctCountLimit

		-- when @pLogResults = 0 @isFirstColumn = 0 (first iteration of column loop) temp tables are created by replacing SELECT INTO with INSERT INTO
		SET @isFirstColumn = 0;
		FETCH NEXT FROM column_table_cur INTO 
			@column_name
			,@data_type

		END -- column_table_cur loop end

		CLOSE column_table_cur;
		DEALLOCATE column_table_cur;

		FETCH NEXT FROM table_cur INTO 
			@schema_name
			,@table_name;
		
		--------------------------------------------------------------------
		-- if @pLogResults = 0 then show this table's profile results
		-- then reset for next table: DROP this sessions tempdb tables; @isFirstColumn = 1
		--------------------------------------------------------------------
		IF @pLogResults = 0
		BEGIN
			PRINT('reset temp tables')
			SET @sql = '
SELECT * FROM '+@tableProfileTable+';
SELECT * FROM '+@columnProfileTable+';
SELECT * FROM '+@columnHistogramTable+';';
			PRINT(@sql);
			EXEC(@sql);

		BEGIN TRANSACTION
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @tableProfileTable)
				EXEC('DROP TABLE '+@TableProfileTable);
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @columnProfileTable)
				EXEC('DROP TABLE '+@ColumnProfileTable);
			IF EXISTS (SELECT 1 FROM tempdb.sys.tables AS tab WHERE tab.name = @columnHistogramTable)
				EXEC('DROP TABLE '+@ColumnHistogramTable);
		COMMIT
		END
		SET @isFirstColumn = 1;

	END -- table_cur loop end

	CLOSE table_cur;
	DEALLOCATE table_cur;

END
GO
