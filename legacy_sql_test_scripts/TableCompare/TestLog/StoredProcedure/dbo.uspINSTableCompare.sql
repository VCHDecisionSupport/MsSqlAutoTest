PRINT '
	executing dbo.uspInsTableCompare.sql'

USE TestLog
GO

SET NOCOUNT ON;
IF OBJECT_ID('dbo.uspInsTableCompare') IS NOT NULL
BEGIN 
	PRINT 'DROP PROC dbo.uspInsTableCompare;'
	DROP PROC dbo.uspInsTableCompare;
END
GO

IF TYPE_ID('ColumnNamePair') IS NOT NULL
BEGIN 
	PRINT 'TYPE TABLE ColumnNamePair does not exist... DROP';
	DROP TYPE ColumnNamePair;
END
GO
CREATE TYPE ColumnNamePair AS TABLE (
	ColumnNameA NVARCHAR(128) DEFAULT NULL
	,ColumnNameB NVARCHAR(128) DEFAULT NULL
);

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
IF OBJECT_ID('dbo.uspInsTableCompare') IS NOT NULL
BEGIN 
	PRINT 'DROP PROC dbo.uspInsTableCompare;'
	DROP PROC dbo.uspInsTableCompare;
END
GO
CREATE PROC dbo.uspInsTableCompare
	@A_qualified_key NVARCHAR(128)
	,@B_qualified_key NVARCHAR(128)
	,@col_tab ColumnNamePair READONLY
	,@debug INT = 0
	,@isRecursive BIT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	IF @debug >= 1 AND @isRecursive = 1
	BEGIN
		PRINT 'this is a recursive call'
	END 
--#region validate key arguments

	/* 
		START: VALIDATE KEY PARAMETERS 
	*/

	/* parse key parameters  */

	DECLARE @A_key_col NVARCHAR(128) = PARSENAME(@A_qualified_key, 1);
	DECLARE @A_tab NVARCHAR(128) = PARSENAME(@A_qualified_key, 2);
	DECLARE @A_schema NVARCHAR(128) = PARSENAME(@A_qualified_key, 3);
	DECLARE @A_db NVARCHAR(128) = PARSENAME(@A_qualified_key, 4);

	DECLARE @B_key_col NVARCHAR(128) = PARSENAME(@B_qualified_key, 1);
	DECLARE @B_tab NVARCHAR(128) = PARSENAME(@B_qualified_key, 2);
	DECLARE @B_schema NVARCHAR(128) = PARSENAME(@B_qualified_key, 3);
	DECLARE @B_db NVARCHAR(128) = PARSENAME(@B_qualified_key, 4);

	DECLARE @A_objID BIGINT;
	DECLARE @B_objID BIGINT;
	DECLARE @A_key_type NVARCHAR(128);
	DECLARE @B_key_type NVARCHAR(128);

	DECLARE @dyn_sql NVARCHAR(4000);
	DECLARE @ParamDefinition NVARCHAR(500);
	
	DECLARE @message NVARCHAR(MAX);
	DECLARE @log_results BIT = 1;
	
	/*	validate parameter format (<database>.<schema>.<table>.<column>)*/
	IF @A_key_col IS NULL
		OR @A_tab IS NULL
		OR @A_schema IS NULL
		OR @A_db IS NULL
	BEGIN
		PRINT ' * * * * * '
		PRINT 'Error: Invalid @A_qualified_key: ' + @A_qualified_key
		PRINT 'both @A_qualified_key and @B_qualified_key must be fully specified columns (<database>.<schema>.<table>.<PK column>)'
		PRINT ' * * * * * '
		RETURN
	END

	IF @B_key_col IS NULL
		OR @B_tab IS NULL
		OR @B_schema IS NULL
		OR @B_db IS NULL
	BEGIN
		PRINT ' * * * * * '
		PRINT 'Error: Invalid @B_qualified_key: ' + @B_qualified_key
		PRINT 'both @A_qualified_key and @B_qualified_key must be fully specified columns (<database>.<schema>.<table>.<PK column>)'
		PRINT ' * * * * * '
		RETURN
	END

	PRINT ''
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------'

	SET @message = 'COMPARE TABLE A: 
	' + @A_db + '.' + @A_schema + '.' + @A_tab + '
TO TABLE B: 
	' + @B_db + '.' + @B_schema + '.' + @B_tab +'
ON SERVER/INSTANCE: '+@@SERVERNAME+'
SUSER_NAME: '+SUSER_NAME()
	PRINT @message;

	/* confirm tables exist, column types match */
	/* get object_id for @B_tab, type for @B_key_col */
	SET @dyn_sql = 'SELECT @object_idOUT = tab.object_id 
	,@type_nameOUT = typ.name
	FROM ' + @A_db + '.sys.schemas AS sch
	INNER JOIN ' + @A_db + '.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	INNER JOIN ' + @A_db + '.sys.columns AS col
	ON col.object_id = tab.object_id
	INNER JOIN ' + @A_db + '.sys.types AS typ
	ON typ.system_type_id = col.system_type_id
	WHERE sch.name = ''' + @A_schema + '''
	AND tab.name = ''' + @A_tab + '''
	AND col.name = ''' + @A_key_col + ''''

	SET @ParamDefinition = N'@object_idOUT bigint OUT, @type_nameOUT NVARCHAR(128) OUT'

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@object_idOUT = @A_objID OUTPUT
		,@type_nameOUT = @A_key_type OUTPUT

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	IF @A_objID IS NULL
	BEGIN
		PRINT ' * * * * * '
		PRINT 'Error: Column does not exist @A_qualified_key: ' + @A_qualified_key
		PRINT 'both @A_qualified_key and @B_qualified_key must be fully specified columns (<database>.<schema>.<table>.<PK column>)'
		PRINT ' * * * * * '
		RETURN
	END

	/* get object_id for @B_tab, type for @B_key_col */
	SET @dyn_sql = 'SELECT @object_idOUT = tab.object_id 
	,@type_nameOUT = typ.name
	FROM ' + @B_db + '.sys.schemas AS sch
	INNER JOIN ' + @B_db + '.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	INNER JOIN ' + @B_db + '.sys.columns AS col
	ON col.object_id = tab.object_id
	INNER JOIN ' + @B_db + '.sys.types AS typ
	ON typ.system_type_id = col.system_type_id
	WHERE sch.name = ''' + @B_schema + '''
	AND tab.name = ''' + @B_tab + '''
	AND col.name = ''' + @B_key_col + ''''

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	SET @ParamDefinition = N'@object_idOUT bigint OUT, @type_nameOUT NVARCHAR(128) OUT'

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@object_idOUT = @B_objID OUTPUT
		,@type_nameOUT = @B_key_type OUTPUT

	IF @B_objID IS NULL
	BEGIN
		PRINT ' * * * * * '
		PRINT 'Error: Column does not exist @B_qualified_key: ' + @B_qualified_key
		PRINT 'both @A_qualified_key and @B_qualified_key must be fully specified columns (<database>.<schema>.<table>.<PK column>)'
		PRINT ' * * * * * '
		RETURN
	END

	IF @A_key_type <> @B_key_type
	BEGIN
		PRINT ' * * * * * '
		PRINT 'WARNING: Key Columns types do not match @A_key_type <> @B_key_type ' + @A_key_type + ' <> ' + @B_key_type
		PRINT ' * * * * * '
	END
	/* 
		END: VALIDATE KEY PARAMETERS
	*/
--#endregion validate key arguments
	IF @debug >= 1
	BEGIN
		PRINT ''
		SET @message = FORMATMESSAGE('Given primary key columns exist... comparing primary keys.');
		PRINT @message;
	END
	
--#region compare given keys

	/* 
		START PRIMARY KEY COMPARISON 
	*/
	DECLARE @TableARowCount INT;
	DECLARE @TableADistinctCount INT;
	DECLARE @TableANullCount INT;
	DECLARE @TableBRowCount INT;
	DECLARE @TableBDistinctCount INT;
	DECLARE @TableBNullCount INT;
	DECLARE @KeyMatchCount INT;

	SET @ParamDefinition = N'
		@KeyMatchCountOUT INT OUTPUT';

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@KeyMatchCountOUT = ISNULL(COUNT(*),0)
	FROM ' + @B_db + '.' + @B_schema + '.' + @B_tab + ' AS B
	INNER JOIN ' + @A_db + '.' + @A_schema + '.' + @A_tab + ' AS A
	ON B.' + @B_key_col + ' = A.' + @A_key_col

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END
	PRINT 'KeyMatchCount'

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@KeyMatchCountOUT = @KeyMatchCount OUTPUT
	PRINT @KeyMatchCount


	SET @ParamDefinition = N'
		@TableARowCountOUT INT OUTPUT
		,@TableADistinctCountOUT INT OUTPUT
		,@TableANullCountOUT INT OUTPUT'

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@TableARowCountOUT = ISNULL(COUNT(*),0)
		,@TableADistinctCountOUT = ISNULL(COUNT(DISTINCT A.' + @A_key_col + '),0)
		,@TableANullCountOUT = ISNULL(SUM(CASE WHEN A.' + @A_key_col + ' IS NULL THEN 1 ELSE 0 END), 0)
	FROM ' + @A_db + '.' + @A_schema + '.' + @A_tab + ' AS A'

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@TableARowCountOUT = @TableARowCount OUTPUT
		,@TableADistinctCountOUT = @TableADistinctCount OUTPUT
		,@TableANullCountOUT = @TableANullCount OUTPUT
	PRINT @TableARowCount 
	PRINT @TableADistinctCount
	PRINT @TableANullCount


	SET @ParamDefinition = N'
		@TableBRowCountOUT INT OUTPUT
		,@TableBDistinctCountOUT INT OUTPUT
		,@TableBNullCountOUT INT OUTPUT'

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@TableBRowCountOUT = ISNULL(COUNT(*),0)
		,@TableBDistinctCountOUT = ISNULL(COUNT(DISTINCT B.' + @B_key_col + '),0)
		,@TableBNullCountOUT = ISNULL(SUM(CASE WHEN B.' + @B_key_col + ' IS NULL THEN 1 ELSE 0 END), 0)
	FROM ' + @B_db + '.' + @B_schema + '.' + @B_tab + ' AS B'

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@TableBRowCountOUT = @TableBRowCount OUTPUT
		,@TableBDistinctCountOUT = @TableBDistinctCount OUTPUT
		,@TableBNullCountOUT = @TableBNullCount OUTPUT
	PRINT @TableBRowCount 
	PRINT @TableBDistinctCount
	PRINT @TableBNullCount
	/* 
		END PRIMARY KEY COMPARISON 
	*/
--#endregion compare given keys
	IF @debug >= 1
	BEGIN
		PRINT ''
		SET @message = FORMATMESSAGE('Logging primary key comparison results to TestLog.dbo.KeyComparison.');
		PRINT @message;
	END
	
--#region log primary key comparison

	/* 
		START LOG PRIMARY KEY COMPARISON 
	*/
	DECLARE @KeyComparisonID INT;
	DECLARE @output TABLE (ID INT);
	DELETE @output;

	IF @log_results = 1
	BEGIN
		INSERT INTO TestLog.dbo.KeyComparison
		OUTPUT inserted.KeyComparisonID INTO @output
		VALUES (
			ISNULL(@KeyMatchCount, 0)
			,SUSER_NAME()
			,GETDATE()
		);

		SELECT TOP 1 @KeyComparisonID = ID FROM @output;

		INSERT INTO TestLog.dbo.KeyColumn
		VALUES (
			@KeyComparisonID
			,@A_key_col
			,@A_key_type
			,ISNULL(@TableARowCount,0) - ISNULL(@KeyMatchCount,0)
			,ISNULL(@TableARowCount,0) - ISNULL(@TableADistinctCount,0)
			,ISNULL(@TableADistinctCount,0)
			,@A_db
			,@A_schema
			,@A_tab
			,@A_objID
			);

		INSERT INTO TestLog.dbo.KeyColumn
		VALUES (
			@KeyComparisonID
			,@B_key_col
			,@B_key_type
			,ISNULL(@TableBRowCount,0) - ISNULL(@KeyMatchCount,0)
			,ISNULL(@TableBRowCount,0) - ISNULL(@TableBDistinctCount,0)
			,ISNULL(@TableBDistinctCount,0)
			,@B_db
			,@B_schema
			,@B_tab
			,@B_objID
			);
	END
	/* 
		END LOG PRIMARY KEY COMPARISON 
	*/
--#endregion log primary key comparison
	PRINT '';
	SET @message = FORMATMESSAGE('Primary key comparison results logged with KeyComparisonID: %s.',CAST(@KeyComparisonID AS NVARCHAR));
	PRINT @message;
	IF @KeyMatchCount = 0
	BEGIN
		SET @message = FORMATMESSAGE('No rows of key column joined!!!',CAST(@KeyComparisonID AS NVARCHAR));
		PRINT @message;
	END
	PRINT '';
	PRINT '';


	/*
		START OF COLUMN VALUE COMPARISONS
	*/
	DECLARE @A_comp_col NVARCHAR(128);
	DECLARE @B_comp_col NVARCHAR(128);
	DECLARE @A_comp_type NVARCHAR(128);
	DECLARE @B_comp_type NVARCHAR(128);
	IF NOT EXISTS(SELECT * FROM @col_tab) AND @isRecursive = 0
	BEGIN
		/* suggest column pairings */
		SET @message = FORMATMESSAGE('no value column pairings given; consider following suggestions.')
		PRINT ''
		PRINT @message
		--PRINT '------------------------------------------------------------------------------------------'
		SET @dyn_sql = 'DECLARE col_pr CURSOR
		FOR 
		WITH A AS(
			SELECT
			col.name
			FROM ' + @A_db + '.sys.schemas AS sch
			INNER JOIN ' + @A_db + '.sys.tables AS tab
			ON sch.schema_id = tab.schema_id
			INNER JOIN ' + @A_db + '.sys.columns AS col
			ON col.object_id = tab.object_id
			INNER JOIN ' + @A_db + '.sys.types AS typ
			ON typ.system_type_id = col.system_type_id
			WHERE sch.name = ''' + @A_schema + '''
			AND tab.name = ''' + @A_tab + '''
		), B AS (
			SELECT
			col.name
			FROM ' + @B_db + '.sys.schemas AS sch
			INNER JOIN ' + @B_db + '.sys.tables AS tab
			ON sch.schema_id = tab.schema_id
			INNER JOIN ' + @B_db + '.sys.columns AS col
			ON col.object_id = tab.object_id
			INNER JOIN ' + @B_db + '.sys.types AS typ
			ON typ.system_type_id = col.system_type_id
			WHERE sch.name = ''' + @B_schema + '''
			AND tab.name = ''' + @B_tab + '''
		)
		SELECT A.name, B.name
		FROM A
		INNER JOIN B
		ON A.name = B.name';
		IF @debug > 1
		BEGIN 
			PRINT ''
			PRINT @dyn_sql
		END 
		EXEC(@dyn_sql);

		OPEN col_pr;

		FETCH NEXT
		FROM col_pr
		INTO @A_comp_col ,@B_comp_col;
		
		SET @message = FORMATMESSAGE('----------------  RUN THIS ----------------------
SET NOCOUNT ON;
DECLARE @A_qualified_key varchar(128) = '''+@A_qualified_key+''';
DECLARE @B_qualified_key varchar(128) = '''+@B_qualified_key+''';

');
		PRINT @message;
		SET @message = FORMATMESSAGE('DECLARE @column_pairings ColumnNamePair;');
		PRINT @message;
		DECLARE @column_pairings ColumnNamePair;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @message = FORMATMESSAGE('INSERT INTO @column_pairings VALUES(''%s'',''%s'');',@A_comp_col ,@B_comp_col);
			PRINT @message;
			INSERT INTO @column_pairings VALUES(@A_comp_col ,@B_comp_col);
			FETCH NEXT
			FROM col_pr
			INTO @A_comp_col ,@B_comp_col;

		END

		CLOSE col_pr;
		DEALLOCATE col_pr;
		SET @message = 'EXEC dbo.uspInsTableCompare @A_qualified_key, @B_qualified_key, @column_pairings;'
		PRINT @message
		PRINT '-------------------- END OF SUGGESTED SCRIPT ---------------------------'
		SET @message = FORMATMESSAGE('reexecuting myself with these suggestions...');
		/*
			recursive call
		*/
		EXEC dbo.uspInsTableCompare @A_qualified_key, @B_qualified_key, @column_pairings, @debug, 1;
	END
	ELSE
	BEGIN

	
		DECLARE @skip_column_comparison BIT = 0;
		DECLARE col_cur CURSOR
		FOR
		SELECT *
		FROM @col_tab;

		OPEN col_cur;

		FETCH NEXT
		FROM col_cur
		INTO @A_comp_col ,@B_comp_col;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			/* 
				START VALIDATE COLUMN PARAMETERS (OF THIS PAIR OF COLUMNS)
			*/
			PRINT ''
			PRINT ''
			--PRINT '------------------------------------------------------------------------------------------'
			SET @message = 'VALUE COLUMN A: 
			' + @A_comp_col + '
		TO VALUE COLUMN B: 
			' + @B_comp_col
			PRINT @message;
			/* confirm column types match */
			/* get type for @A_comp_col */
			SET @dyn_sql = 'SELECT @type_nameOUT = typ.name
			FROM ' + @A_db + '.sys.schemas AS sch
			INNER JOIN ' + @A_db + '.sys.tables AS tab
			ON sch.schema_id = tab.schema_id
			INNER JOIN ' + @A_db + '.sys.columns AS col
			ON col.object_id = tab.object_id
			INNER JOIN ' + @A_db + '.sys.types AS typ
			ON typ.system_type_id = col.system_type_id
			WHERE sch.name = ''' + @A_schema + '''
			AND tab.name = ''' + @A_tab + '''
			AND col.name = ''' + @A_comp_col + ''''

			SET @ParamDefinition = N'@type_nameOUT NVARCHAR(128) OUT'

			EXEC sp_executesql @dyn_sql
				,@ParamDefinition
				,@type_nameOUT = @A_comp_type OUTPUT

			IF @debug > 1
				PRINT @dyn_sql

			/* get type for @B_comp_col */
			SET @dyn_sql = 'SELECT @type_nameOUT = typ.name
			FROM ' + @B_db + '.sys.schemas AS sch
			INNER JOIN ' + @B_db + '.sys.tables AS tab
			ON sch.schema_id = tab.schema_id
			INNER JOIN ' + @B_db + '.sys.columns AS col
			ON col.object_id = tab.object_id
			INNER JOIN ' + @B_db + '.sys.types AS typ
			ON typ.system_type_id = col.system_type_id
			WHERE sch.name = ''' + @B_schema + '''
			AND tab.name = ''' + @B_tab + '''
			AND col.name = ''' + @B_comp_col + ''''

			IF @debug > 1

				PRINT @dyn_sql

			SET @ParamDefinition = N'@type_nameOUT NVARCHAR(128) OUT'

			EXEC sp_executesql @dyn_sql
				,@ParamDefinition
				,@type_nameOUT = @B_comp_type OUTPUT


			IF @A_comp_type <> @B_comp_type
			BEGIN
				PRINT ' * * * * * '
				PRINT 'WARNING: Key Columns types do not match @A_comp_type <> @B_comp_type:  ' + @A_comp_type + ' <> ' + @B_comp_type
				PRINT ' * * * * * '
				RAISERROR ('WARNING: Key Columns types do not match',1,1) WITH NOWAIT
				--RETURN
			END
			/* 
				END VALIDATE COLUMN PARAMETERS
			*/
			/* 
				START COLUMN VALUE COMPARISON (OF THIS PAIR OF COLUMNS)
			*/
			DECLARE @ValueMatchCount INT;
			DECLARE @A_col_null_count INT;
			DECLARE @B_col_null_count INT;
			DECLARE @A_col_distinct_count INT;
			DECLARE @B_col_distinct_count INT;

			SET @ParamDefinition = N'
				@ValueMatchCountOUT INT OUTPUT
				,@A_col_null_countOUT INT OUTPUT
				,@A_col_distinct_countOUT INT OUTPUT
				,@B_col_null_countOUT INT OUTPUT
				,@B_col_distinct_countOUT INT OUTPUT
				';

			SET @dyn_sql = '
			SELECT
				@ValueMatchCountOUT = ISNULL(SUM(CASE WHEN A.' + @A_comp_col + ' = B.' + @B_comp_col + ' THEN 1 ELSE 0 END), 0)
				,@A_col_null_countOUT = ISNULL(SUM(CASE WHEN A.' + @A_comp_col + ' IS NULL THEN 1 ELSE 0 END), 0)
				,@A_col_distinct_countOUT = ISNULL(COUNT(DISTINCT A.' + @A_comp_col + '), 0)
				,@B_col_null_countOUT = ISNULL(SUM(CASE WHEN B.' + @B_comp_col + ' IS NULL THEN 1 ELSE 0 END), 0)
				,@B_col_distinct_countOUT = ISNULL(COUNT(DISTINCT B.' + @B_comp_col + '), 0)
			FROM ' + @B_db + '.' + @B_schema + '.' + @B_tab + ' AS B
			INNER JOIN ' + @A_db + '.' + @A_schema + '.' + @A_tab + ' AS A
			ON B.' + @B_key_col + ' = A.' + @A_key_col

			EXEC sp_executesql @dyn_sql
				,@ParamDefinition
				,@ValueMatchCountOUT = @ValueMatchCount OUTPUT
				,@A_col_null_countOUT = @A_col_null_count OUTPUT
				,@A_col_distinct_countOUT = @A_col_distinct_count OUTPUT
				,@B_col_null_countOUT = @B_col_null_count OUTPUT
				,@B_col_distinct_countOUT = @B_col_distinct_count OUTPUT

			/* get counts of full column (not just counts of rows with matched keys) */
			DECLARE @A_full_col_null_count INT;
			DECLARE @B_full_col_null_count INT;
			DECLARE @A_full_col_distinct_count INT;
			DECLARE @B_full_col_distinct_count INT;
			SET @ParamDefinition = N'
				@A_full_col_null_countOUT INT OUTPUT
				,@A_full_col_distinct_countOUT INT OUTPUT';

			SET @dyn_sql = '
			SELECT
				@A_full_col_null_countOUT = ISNULL(SUM(CASE WHEN A.' + @A_comp_col + ' IS NULL THEN 1 ELSE 0 END), 0)
				,@A_full_col_distinct_countOUT = ISNULL(COUNT(DISTINCT A.' + @A_comp_col + '), 0)
			FROM ' + @A_db + '.' + @A_schema + '.' + @A_tab + ' AS A';

			EXEC sp_executesql @dyn_sql
				,@ParamDefinition
				,@A_full_col_null_countOUT = @A_full_col_null_count OUTPUT
				,@A_full_col_distinct_countOUT = @A_full_col_distinct_count OUTPUT

			SET @ParamDefinition = N'
				@B_full_col_null_countOUT INT OUTPUT
				,@B_full_col_distinct_countOUT INT OUTPUT';

			SET @dyn_sql = '
			SELECT
				@B_full_col_null_countOUT = ISNULL(SUM(CASE WHEN B.' + @B_comp_col + ' IS NULL THEN 1 ELSE 0 END), 0)
				,@B_full_col_distinct_countOUT = ISNULL(COUNT(DISTINCT B.' + @B_comp_col + '), 0)
			FROM ' + @B_db + '.' + @B_schema + '.' + @B_tab + ' AS B';

			EXEC sp_executesql @dyn_sql
				,@ParamDefinition
				,@B_full_col_null_countOUT = @B_full_col_null_count OUTPUT
				,@B_full_col_distinct_countOUT = @B_full_col_distinct_count OUTPUT
			/* 
				END COLUMN VALUE COMPARISON 
			*/

			/* 
				START LOG VALUE COMPARISON (OF THIS PAIR OF COLUMNS)
			*/
			IF @log_results = 1
			DELETE @output;
			BEGIN
				DECLARE @ValueComparisonID INT;
				
				INSERT INTO TestLog.dbo.ValueComparison
				OUTPUT inserted.ValueComparisonID INTO @output
				VALUES (
					@KeyComparisonID
					,ISNULL(@ValueMatchCount,0)
					);

				SELECT TOP 1 @ValueComparisonID = ID FROM @output;
				INSERT INTO TestLog.dbo.ValueColumn
				VALUES (
					@ValueComparisonID
					,@A_comp_col
					,@A_comp_type
					,ISNULL(@KeyMatchCount,0) - ISNULL(@ValueMatchCount,0)
					,ISNULL(@A_col_null_count,0)
					,ISNULL(@A_col_distinct_count,0)
					,ISNULL(@A_full_col_null_count,0)
					,ISNULL(@A_full_col_distinct_count,0)
				);
				INSERT INTO TestLog.dbo.ValueColumn
				VALUES (
					@ValueComparisonID
					,@B_comp_col
					,@B_comp_type
					,ISNULL(@KeyMatchCount,0) - ISNULL(@ValueMatchCount,0)
					,ISNULL(@B_col_null_count,0)
					,ISNULL(@B_col_distinct_count,0)
					,ISNULL(@B_full_col_null_count,0)
					,ISNULL(@B_full_col_distinct_count,0)
				);
				/* 
					END LOG VALUE COMPARISON (OF THIS PAIR OF COLUMNS)
				*/
				SET @message = FORMATMESSAGE('Column value comparison results logged with ValueComparisonID: %s.',CAST(@ValueComparisonID AS NVARCHAR));
				PRINT @message;
			END

			FETCH NEXT
			FROM col_cur
			INTO @A_comp_col ,@B_comp_col;
		END
		SELECT *
		FROM TestLog.dbo.vwKeyColumnCompare
		WHERE SUserLogin = SUSER_NAME()
		ORDER BY ComparisonDate DESC, KeyComparisonID DESC
		IF @KeyMatchCount > 0
		BEGIN
			SELECT vw.*
			FROM TestLog.dbo.vwValueColumnCompare AS vw
			JOIN TestLog.dbo.vwKeyColumnCompare AS parent
			ON vw.KeyComparisonID = parent.KeyComparisonID
			WHERE parent.SUserLogin = SUSER_NAME()
			ORDER BY ComparisonDate DESC, KeyComparisonID DESC
		END
	END
	/*
		END OF COLUMN VALUE COMPARISONS
	*/
END
GO
