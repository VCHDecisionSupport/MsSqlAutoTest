PRINT '
	executing dbo.fntMetaCompare.sql'

USE TestLog
GO

SET NOCOUNT ON;
IF OBJECT_ID('dbo.fntMetaCompare') IS NULL
BEGIN 
	PRINT 'CREATE FUNCTION dbo.fntMetaCompare;'
	DECLARE @sql varchar(max) = '
CREATE FUNCTION dbo.fntMetaCompare
	(@A_qualified_key varchar(128)
	,@B_qualified_key varchar(128)
	,@debug INT = 0)
	RETURNS @columnMatches TABLE
	   (
	    ColumnNameA varchar(256),
	    ColumnNameB varchar(256)
	   )
AS
BEGIN
	RETURN 
END'
PRINT @sql
EXEC(@sql)
END
GO

ALTER FUNCTION dbo.fntMetaCompare(@A_qualified_key varchar(128)
	,@B_qualified_key varchar(128)
	,@debug INT = 0)
	RETURNS @columnMatches TABLE
	   (
	    ColumnNameA varchar(256),
	    ColumnNameB varchar(256)
	   )
AS
BEGIN
	DECLARE @A_key_col varchar(128) = PARSENAME(@A_qualified_key, 1);
	DECLARE @A_tab varchar(128) = PARSENAME(@A_qualified_key, 2);
	DECLARE @A_schema varchar(128) = PARSENAME(@A_qualified_key, 3);
	DECLARE @A_db varchar(128) = PARSENAME(@A_qualified_key, 4);

	DECLARE @B_key_col varchar(128) = PARSENAME(@B_qualified_key, 1);
	DECLARE @B_tab varchar(128) = PARSENAME(@B_qualified_key, 2);
	DECLARE @B_schema varchar(128) = PARSENAME(@B_qualified_key, 3);
	DECLARE @B_db varchar(128) = PARSENAME(@B_qualified_key, 4);
	
	DECLARE @dyn_sql varchar(4000);
	DECLARE @ParamDefinition varchar(500);
	SET @dyn_sql = '
		INSERT @columnMatches
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
		ON A.name = B.name'
	EXEC(@dyn_sql);
	RETURN
END
GO

DECLARE @A_qualified_key varchar(128);
DECLARE @B_qualified_key varchar(128);
SET @A_qualified_key = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID'
SET @B_qualified_key = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum'

SELECT *
FROM dbo.fntMetaCompare(@A_qualified_key,@B_qualified_key,1);