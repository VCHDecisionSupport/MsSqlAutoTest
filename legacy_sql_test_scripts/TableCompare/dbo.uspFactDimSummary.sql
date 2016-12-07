USE CommunityMart
GO

--IF OBJECT_ID('dbo.uspGetFactDimSummary','P') IS NULL
--BEGIN 
--	EXEC('CREATE PROC dbo.uspGetFactDimSummary AS')
--	PRINT 'CREATE PROC dbo.uspGetFactDimSummary AS'
--END;
--GO

DECLARE @pFactTableName varchar(255) = 'SchoolHistoryFact';
DECLARE @report_cutoff_start_date int = 20120401
DECLARE @pDebug int = 10;

--ALTER PROC dbo.uspGetFactDimSummary
--	@pFactTableName varchar(255)
--    ,@pDebug tinyint = 0
--AS
	SET @sql = FORMATMESSAGE('SELECT @row_countOUT = COUNT(*) FROM %s',@pFactTableName);
	SET @params = N'@row_countOUT int OUTPUT';
	EXEC sp_executesql @sql, @params, @row_countOUT = @row_count OUT;

BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	IF @pDebug > 0 RAISERROR( 'dbo.uspGetFactDimSummary: @pFactTableName = %s.', 0, 1, @pFactTableName) WITH NOWAIT;

	DECLARE @sql nvarchar(max);
	DECLARE @params nvarchar(max);
	DECLARE @where_filter nvarchar(max) = ' WHERE SchoolDtlStartDateID > '+CAST(@report_cutoff_start_date AS varchar(10))
	DECLARE @message nvarchar(max);

	DECLARE @full_summary_sql nvarchar(max) = 'SELECT ''*'' AS column_name, COUNT(*) AS distinct_count, NULL AS column_value, NULL AS group_row_count, 100 AS [percent] FROM '+@pFactTableName + @where_filter;

	DECLARE @column_name varchar(255);

	DECLARE @max_group_count int = 500;

	DECLARE @row_count int;
	DECLARE @dis_count int;


	DECLARE cur cursor
	FOR
	SELECT 
		--sch.name AS schema_name
		--,tab.object_id
		--,tab.name AS table_name
		--,col.column_id
		col.name AS column_name
		--,typ.name AS type_name
	FROM sys.schemas AS sch
	JOIN sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	JOIN sys.columns AS col
	ON tab.object_id = col.object_id
	JOIN sys.types AS typ
	ON col.system_type_id = typ.system_type_id
	WHERE tab.name = @pFactTableName
	AND typ.name LIKE '%int%'

	OPEN cur;


	FETCH NEXT FROM cur INTO @column_name;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @message = FORMATMESSAGE('	column_name: %s', @column_name);
		PRINT @message;

		SET @params = N'@row_countOUT int OUTPUT, @dis_countOUT int OUTPUT'
		SET @sql = N'SELECT @row_countOUT = COUNT(*), @dis_countOUT = COUNT(DISTINCT '+@column_name+') FROM '+@pFactTableName + @where_filter;
		--PRINT @sql;
		EXEC sp_executesql @sql, @params, @row_countOUT = @row_count OUT, @dis_countOUT = @dis_count OUT;
		SET @full_summary_sql = @full_summary_sql + FORMATMESSAGE(' UNION SELECT '' %s '' AS column_name, COUNT(DISTINCT %s) AS distinct_count, %s AS column_value, CAST(100.*COUNT(DISTINCT %s)/%i AS numeric(4,1)) AS [percent] FROM %s %s
',@column_name, @column_name, @column_name, @column_name, @row_count, @pFactTableName, @where_filter);
		PRINT @full_summary_sql;
		
		SELECT @message = FORMATMESSAGE('		total row count: %i, distinct count: %i.', @row_count, @dis_count);
		PRINT @message;
		IF @dis_count < @max_group_count
		BEGIN
			SELECT @message = FORMATMESSAGE('			calculating histogram for column: %s', @column_name);
			PRINT @message;
			--SET @sql = 'SELECT '+@column_name+' AS '+@column_name+', COUNT(*) AS row_count, CAST(100.*COUNT(*)/'+@row_count+' AS numeric(3,1)) FROM '+@pFactTableName + @where_filter+' GROUP BY '+@column_name;
			SET @full_summary_sql = @full_summary_sql + FORMATMESSAGE(' UNION SELECT ''%s'' AS column_name, %s AS column_value, COUNT(*) AS group_row_count, CAST(100.*COUNT(*)/%i AS numeric(4,1)) AS [percent] FROM %s %s GROUP BY %s',@column_name,@column_name,@row_count, @pFactTableName, @where_filter, @column_name)
			PRINT @full_summary_sql;

		END


		FETCH NEXT FROM cur INTO @column_name;
	END

	CLOSE cur;
	DEALLOCATE cur; 

	PRINT @full_summary_sql;
	EXEC(@full_summary_sql);

END;
GO

--EXEC dbo.uspGetFactDimSummary @pFactTableName = 'SchoolHistoryFact';