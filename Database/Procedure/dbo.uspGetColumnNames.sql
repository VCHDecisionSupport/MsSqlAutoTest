USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspGetColumnNames';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspGetColumnNames
	@pDatabaseName varchar(100)
	,@pSchemaName varchar(100)
	,@pObjectName varchar(100)
	,@pIntersectingDatabaseName varchar(100) = NULL
	,@pIntersectingSchemaName varchar(100) = NULL
	,@pIntersectingObjectName varchar(100) = NULL
	,@pFmt varchar(max) = ',%s'
	,@pColStr varchar(max) OUTPUT
	,@pSkipPkHash bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspGetColumnNames(%s.%s.%s)'
	RAISERROR(@fmt, 0, 1, @pDatabaseName, @pSchemaName, @pObjectName) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	SET @pIntersectingDatabaseName = ISNULL(@pIntersectingDatabaseName,@pDatabaseName)
	SET @pIntersectingSchemaName = ISNULL(@pIntersectingSchemaName,@pSchemaName)
	SET @pIntersectingObjectName = ISNULL(@pIntersectingObjectName,@pObjectName)

	--RAISERROR(@pFmt, 0, 1) WITH NOWAIT;
	SET @pFmt = ISNULL(@pFmt, ',%s')
	--RAISERROR(@pFmt, 0, 1) WITH NOWAIT;

	SET @param = '
	@pObjectNameIN varchar(200)
	,@pSchemaNameIN varchar(200)
	,@pIntersectingObjectNameIN varchar(200)
	,@pIntersectingSchemaNameIN varchar(200)
	,@pSkipPkHashIN bit
	,@pColStrOUT varchar(max) OUTPUT
	'

	SET @sql = FORMATMESSAGE('
;WITH db_obj AS (
	(
		SELECT col.name AS column_name
		FROM %s.sys.columns as col
		JOIN %s.sys.tables as tab
		ON col.object_id=tab.object_id
		JOIN %s.sys.schemas as sch
		ON tab.schema_id = sch.schema_id
		WHERE 1=1
		AND tab.name = @pObjectNameIN
		AND sch.name = @pSchemaNameIN
		UNION ALL
		SELECT col.name AS column_name
		FROM %s.sys.columns as col
		JOIN %s.sys.views as vw
		ON col.object_id=vw.object_id
		JOIN %s.sys.schemas as sch
		ON vw.schema_id = sch.schema_id
		WHERE 1=1
		AND vw.name = @pObjectNameIN
		AND sch.name = @pSchemaNameIN
	)
INTERSECT
	(
		SELECT col.name AS column_name
		FROM %s.sys.columns as col
		JOIN %s.sys.tables as tab
		ON col.object_id=tab.object_id
		JOIN %s.sys.schemas as sch
		ON tab.schema_id = sch.schema_id
		WHERE 1=1
		AND tab.name = @pIntersectingObjectNameIN
		AND sch.name = @pIntersectingSchemaNameIN
		UNION ALL
		SELECT col.name AS column_name
		FROM %s.sys.columns as col
		JOIN %s.sys.views as vw
		ON col.object_id=vw.object_id
		JOIN %s.sys.schemas as sch
		ON vw.schema_id = sch.schema_id
		WHERE 1=1
		AND vw.name = @pIntersectingObjectNameIN
		AND sch.name = @pIntersectingSchemaNameIN
	)
) 
SELECT @pColStrOUT = SUBSTRING((
SELECT REPLACE(''%s'', ''%s'',db_obj.column_name)
FROM db_obj
WHERE (db_obj.column_name LIKE ''__pkhash__'' AND @pSkipPkHashIN = 0)
OR db_obj.column_name NOT LIKE ''__pkhash__''
ORDER BY db_obj.column_name
FOR XML PATH('''')),1,10000)
'
,@pDatabaseName, @pDatabaseName, @pDatabaseName, @pDatabaseName, @pDatabaseName, @pDatabaseName
,@pIntersectingDatabaseName, @pIntersectingDatabaseName, @pIntersectingDatabaseName, @pIntersectingDatabaseName, @pIntersectingDatabaseName, @pIntersectingDatabaseName
,@pFmt,'%s')

	--RAISERROR(@sql, 0, 1) WITH NOWAIT;

	EXEC sp_executesql @sql, @param, @pSchemaNameIN = @pSchemaName, @pObjectNameIN = @pObjectName, @pIntersectingSchemaNameIN = @pIntersectingSchemaName, @pIntersectingObjectNameIN = @pIntersectingObjectName, @pSkipPkHashIN = @pSkipPkHash, @pColStrOUT = @pColStr OUTPUT 

	SET @pColStr = LTRIM(RTRIM(@pColStr))
	IF CHARINDEX(',',@pColStr,1) = 1
		SET @pColStr = SUBSTRING(@pColStr, 2, LEN(@pColStr))
	IF CHARINDEX(',',REVERSE(@pColStr),1) = 1
		SET @pColStr = SUBSTRING(@pColStr, 1, LEN(@pColStr)-1)
	SET @pColStr = @pColStr

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspGetColumnNames: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspGetColumnNames
--DECLARE 
--	@pDatabaseName varchar(100) = 'Lien'
--	,@pSchemaName varchar(100) = 'Adtc'
--	,@pObjectName varchar(100) = 'SM_02_DischargeFact'
--	,@pIntersectingDatabaseName varchar(100) = 'Lien'
--	,@pIntersectingSchemaName varchar(100) = 'Adtc'
--	,@pIntersectingObjectName varchar(100) = 'SM_02_DischargeFact'
--	,@pFmt varchar(max) = 'pre.%s,'
--	,@pColStr varchar(max)
--SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'
--EXEC dbo.uspGetColumnNames 
--	@pDatabaseName
--	,@pSchemaName
--	,@pObjectName
--	,@pFmt = @pFmt
--	,@pColStr = @pColStr OUTPUT

--PRINT @pColStr
