DECLARE 
	@DatabaseName varchar(100) = 'DSDW',
	@ObjectName varchar(100) = 'Community.ReferralFact',
	@ColumnName varchar(100) = '',
	@ColumnValue varchar(100) = null

--DECLARE @ObjectName varchar(100) = '[Dim].[Gender]'
--DECLARE @DatabaseName varchar(100) = 'CommunityMart'

BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	DECLARE @fmt nvarchar(500);

	-- break up user input into parts, fill in missing parts with defaults
	DECLARE @schema_name sysname;
	DECLARE @table_name sysname;
	SET @schema_name = PARSENAME(@ObjectName, 2)
	SET @table_name = PARSENAME(@ObjectName, 1)

	DECLARE @full_table_name nvarchar(300) = FORMATMESSAGE('%s.%s.%s',@DatabaseName,@schema_name,@table_name);

	DECLARE @object_id int = OBJECT_ID(@full_table_name);
	
	DECLARE @sql nvarchar(max);

	DECLARE @table_row_count int;
	DECLARE @param nvarchar(500);
	DECLARE @filter_clause nvarchar(500);

	SELECT @filter_clause = CASE WHEN (@ColumnName IS NULL OR @ColumnName = '') THEN ' AND 1=1 ' ELSE FORMATMESSAGE(' AND CAST(%s AS varchar(1000)) = ''%s'' ', @ColumnName, CAST(@ColumnValue AS varchar(100))) END;
	-- PRINT @filter_clause;
	SET @sql = FORMATMESSAGE(N'SELECT @table_row_countOUT = COUNT(*) FROM %s WHERE 1=1 %s', @full_table_name, @filter_clause);
	SET @param = '@table_row_countOUT int OUT';
	-- PRINT @sql
	EXEC sp_executesql @sql, @param, @table_row_countOUT = @table_row_count OUT;

	--SET @sql = FORMAT(@table_row_count, 'N0');
	--RAISERROR ('Table Row Count: %s', 0, 1, @sql);
	--PRINT ''

	IF OBJECT_ID('tempdb..#table_summary_counts','U') IS NOT NULL
	BEGIN
		DROP TABLE #table_summary_counts;
	END

	CREATE TABLE #table_summary_counts 
	(
		column_name nvarchar(300)
		,column_type varchar(20)
		,null_count int
		,distinct_count int
		,zero_count int
		,blank_count int
		,column_id int
	);


	SET @sql = N'
	INSERT INTO #table_summary_counts (column_name, column_type, column_id)
	SELECT 
		col.name AS column_name
		,CASE
			WHEN typ.name LIKE ''%char%'' AND col.max_length = -1 THEN FORMATMESSAGE(''%s(MAX)'',typ.name, col.max_length)
			WHEN typ.name LIKE ''%char%'' THEN FORMATMESSAGE(''%s(%i)'',typ.name, col.max_length)
			ELSE typ.name
		END AS column_type
		,col.column_id
	FROM '+@DatabaseName+'.sys.columns AS col
	JOIN '+@DatabaseName+'.sys.types AS typ
	ON col.system_type_id = typ.system_type_id
	WHERE object_id = '+CAST(@object_id AS varchar(10))+'
	ORDER BY col.object_id ASC;'

	EXEC(@sql);

	DECLARE cur CURSOR FAST_FORWARD
	FOR 
	SELECT column_name, column_type
	FROM #table_summary_counts;

	DECLARE 
		@column_name sysname
		,@column_type sysname
		,@null_count int
		,@distinct_count int
		,@zero_count int
		,@blank_count int
	
	OPEN cur;

	FETCH NEXT FROM cur INTO @column_name, @column_type;
	DECLARE @full_column_name nvarchar(300);
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @null_count = NULL, @distinct_count = NULL, @zero_count = NULL, @blank_count = NULL;
		IF @column_type NOT IN ('xml')
		BEGIN
			SET @full_column_name = @full_table_name+'.'+@column_name
			SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL %s;', @full_table_name, @column_name, @filter_clause); 
			SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
			-- PRINT @sql
			EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;

			SET @sql = FORMATMESSAGE(N'SELECT @distinct_countOUT = COUNT(DISTINCT %s) FROM %s WHERE 1=1 %s', @column_name, @full_table_name, @filter_clause); 
			SET @param = FORMATMESSAGE(N'@distinct_countOUT int OUT');
			-- PRINT @sql
			EXEC sp_executesql @sql, @param, @distinct_countOUT = @distinct_count OUT;

			SET @sql = FORMATMESSAGE(N'SELECT @zero_countOUT = COUNT(*) FROM %s WHERE CAST(%s AS varchar(100))= ''0'' %s;', @full_table_name, @column_name, @filter_clause); 
			SET @param = FORMATMESSAGE(N'@zero_countOUT int OUT');
			-- PRINT @sql
			EXEC sp_executesql @sql, @param, @zero_countOUT = @zero_count OUT;

			SET @sql = FORMATMESSAGE(N'SELECT @blank_countOUT = COUNT(*) FROM %s WHERE %s= '''' %s;', @full_table_name, @column_name, @filter_clause); 
			SET @param = FORMATMESSAGE(N'@blank_countOUT int OUT');
			-- PRINT @sql
			EXEC sp_executesql @sql, @param, @blank_countOUT = @blank_count OUT;
		END
		--SELECT  @full_column_name AS full_column_name, @null_count AS null_count, @distinct_count AS distinct_count, @zero_count AS zero_count;
		UPDATE #table_summary_counts
		SET null_count = @null_count
			,distinct_count = @distinct_count
			,zero_count = @zero_count
			,blank_count = @blank_count
		FROM #table_summary_counts
		WHERE column_name = @column_name;
		RAISERROR ('%-30s null_count: %12i   distinct_count: %12i   zero_count: %12i   blank_count: %12i', 0, 1, @column_name, @null_count, @distinct_count, @zero_count, @blank_count) WITH NOWAIT;

		FETCH NEXT FROM cur INTO @column_name, @column_type;
	END

	CLOSE cur;
	DEALLOCATE cur;

	--SELECT 
	--	@DatabaseName AS database_name
	--	,@schema_name AS schema_name
	--	,@table_name AS table_name
	--	,FORMAT(@table_row_count, 'N0') AS table_row_count
	
	DECLARE @null_percent decimal(3,1)
		,@distinct_percent decimal(3,1)
		,@zero_percent decimal(3,1)
		,@blank_percent decimal(3,1)

	IF @table_row_count > 0
	BEGIN
		SET @null_percent = 1.*@null_count/@table_row_count;
		SET @distinct_percent = 1.*@distinct_count/@table_row_count;
		SET @zero_percent = 1.*@zero_count/@table_row_count;
		SET @blank_percent = 1.*@blank_count/@table_row_count;
	END

	SELECT 
		column_name
		,column_type
		-- ,FORMAT(null_count, 'N0') AS null_count
		,null_count
		--,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*null_count/@table_row_count END,'p') AS null_percent
		-- ,FORMAT(distinct_count, 'N0') AS distinct_count
		,distinct_count
		--,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*distinct_count/@table_row_count END,'p') AS distinct_zero
		-- ,FORMAT(zero_count, 'N0') AS zero_count
		,zero_count
		--,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*zero_count/@table_row_count END,'p') AS zero_percent
		,blank_count
	FROM #table_summary_counts
	ORDER BY column_id ASC;

	IF OBJECT_ID('tempdb..#table_summary_counts','U') IS NOT NULL
	BEGIN
		DROP TABLE #table_summary_counts;
	END


END