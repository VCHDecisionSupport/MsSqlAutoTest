USE TestLog
GO
SET NOCOUNT ON;
IF OBJECT_ID('dbo.uspGetMeta') IS NOT NULL
BEGIN 
	PRINT 'DROP PROC dbo.uspGetMeta;'
	DROP PROC dbo.uspGetMeta;
END
GO

DECLARE @A_qualified_key varchar(128) = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID';
DECLARE @B_qualified_key varchar(128) = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum';
DECLARE @script_inserts varchar(128) = 0;
DECLARE @debug INT = 0;
GO
CREATE PROC dbo.uspGetMeta
	@A_qualified_key NVARCHAR(128)
	,@B_qualified_key NVARCHAR(128)
	,@script_inserts BIT = 1
	,@debug INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	/* 
		START: VALIDATE KEY PARAMETERS 
	*/

	/* parse key parameters  */

	DECLARE @A_key_col NVARCHAR(128) = PARSENAME(@A_qualified_key, 1);
	DECLARE @A_tab NVARCHAR(128) = PARSENAME(@A_qualified_key, 2);
	DECLARE @A_schema NVARCHAR(128) = PARSENAME(@A_qualified_key, 3);
	DECLARE @A_db NVARCHAR(128) = PARSENAME(@A_qualified_key, 4);
	DECLARE @A_full_tab NVARCHAR(128) = @A_db +'.'+@A_schema+'.'+@A_tab;
	
	DECLARE @B_key_col NVARCHAR(128) = PARSENAME(@B_qualified_key, 1);
	DECLARE @B_tab NVARCHAR(128) = PARSENAME(@B_qualified_key, 2);
	DECLARE @B_schema NVARCHAR(128) = PARSENAME(@B_qualified_key, 3);
	DECLARE @B_db NVARCHAR(128) = PARSENAME(@B_qualified_key, 4);
	DECLARE @B_full_tab NVARCHAR(128) = @B_db +'.'+@B_schema+'.'+@B_tab;


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

	DECLARE @A_comp_col NVARCHAR(128);
	DECLARE @B_comp_col NVARCHAR(128);
	DECLARE @A_comp_type NVARCHAR(128);
	DECLARE @B_comp_type NVARCHAR(128);
	SET @dyn_sql = '';
	IF @script_inserts = 1
	BEGIN
		/* suggest column pairings */
		SET @message = FORMATMESSAGE('no value column pairings given; consider following suggestions.')
		PRINT ''
		PRINT @message
		PRINT '------------------------------------------------------------------------------------------'
		SET @dyn_sql = '
		DECLARE col_pr CURSOR
		FOR WITH A AS(
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
		SELECT 
			A.name 
			,B.name
		FROM A
		JOIN B
		ON A.name = B.name'
		
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

		SET @message = FORMATMESSAGE('
DECLARE @A_qualified_key varchar(128) = '''+@A_qualified_key+''';
DECLARE @B_qualified_key varchar(128) = '''+@B_qualified_key+''';

DECLARE @column_pairings ColumnNamePair;
');
		PRINT @message;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @message = FORMATMESSAGE('INSERT INTO @column_pairings VALUES(''%s'',''%s'');',@A_comp_col ,@B_comp_col);
			PRINT @message;

			FETCH NEXT
			FROM col_pr
			INTO @A_comp_col ,@B_comp_col;

		END

		CLOSE col_pr;
		DEALLOCATE col_pr;
	END
	ELSE
	BEGIN
		SET @dyn_sql = '
		WITH A AS(
			SELECT
			col.name + '' ''+CASE WHEN typ.name LIKE ''%char'' THEN typ.name+''(''+cast(col.max_length AS VARCHAR(20))+'')'' ELSE typ.name END AS name
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
			col.name + '' ''+CASE WHEN typ.name LIKE ''%char'' THEN typ.name+''(''+cast(col.max_length AS VARCHAR(20))+'')'' ELSE typ.name END AS name
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
		SELECT 
			A.name AS ['+@A_full_tab+']
			,B.name AS ['+@B_full_tab+']
		FROM A
		FULL JOIN B
		ON A.name = B.name'
		PRINT @dyn_sql
		EXEC(@dyn_sql);
	END
END

GO
DECLARE @A_qualified_key varchar(128) = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID';
DECLARE @B_qualified_key varchar(128) = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum';

EXEC TestLog.dbo.uspGetMeta
	@A_qualified_key
	,@B_qualified_key
	,0