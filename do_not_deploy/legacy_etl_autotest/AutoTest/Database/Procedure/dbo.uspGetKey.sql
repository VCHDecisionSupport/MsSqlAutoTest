USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspGetKey';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspGetKey
	@pDatabaseName varchar(100)
	,@pSchemaName varchar(100)
	,@pObjectName varchar(100)
	,@pFmt varchar(max) = ',%s'
	,@pColStr varchar(max) OUTPUT
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SET @pFmt = ISNULL(@pFmt, ',%s')
	SELECT @fmt='dbo.uspGetKey(%s.%s.%s; @pFmt = ''%s'')'
	RAISERROR(@fmt, 0, 1, @pDatabaseName, @pSchemaName, @pObjectName, @pFmt) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	--RAISERROR(@pFmt, 0, 1) WITH NOWAIT;
	--RAISERROR(@pFmt, 0, 1) WITH NOWAIT;

	SET @param = '
	@pDatabaseNameIN varchar(200)
	,@pObjectNameIN varchar(200)
	,@pSchemaNameIN varchar(200)
	,@pColStrOUT varchar(max) OUTPUT
	'

	SET @sql = FORMATMESSAGE('
;WITH DQMF_BizKey AS (
	SELECT attr.AttributePhysicalName AS column_name
	FROM DQMF.dbo.MD_Database AS db
	JOIN DQMF.dbo.MD_Object AS obj
	ON db.DatabaseId = db.DatabaseId
	JOIN DQMF.dbo.MD_ObjectAttribute AS attr
	ON obj.ObjectID = attr.ObjectID
	WHERE 1=1
	AND db.DatabaseName = @pDatabaseNameIN
	AND obj.ObjectSchemaName = @pSchemaNameIN
	AND obj.ObjectPhysicalName = @pObjectNameIN
	AND attr.IsBusinessKey = 1
)
SELECT @pColStrOUT = SUBSTRING((
SELECT REPLACE(''%s'', ''%s'',DQMF_BizKey.column_name)
FROM DQMF_BizKey
ORDER BY DQMF_BizKey.column_name
FOR XML PATH('''')),1,10000)
'
,@pFmt,'%s')

IF DB_ID('DQMF') IS NOT NULL
	EXEC sp_executesql @sql, @param, @pDatabaseNameIN = @pDatabaseName, @pSchemaNameIN = @pSchemaName, @pObjectNameIN = @pObjectName,@pColStrOUT = @pColStr OUTPUT 
ELSE RAISERROR('DQMF database does not exist',0,0);
IF @pColStr IS NULL  OR LEN(@pColStr) = 0
BEGIN
	RAISERROR('No BizKey set in DQMF.dbo.MD_ObjectAttribute.IsBusinessKey',0,1)

SET @sql = FORMATMESSAGE('
;WITH DQMF_PkField AS (
	SELECT DISTINCT obj.ObjectPKField
	FROM DQMF.dbo.MD_Database AS db
	JOIN DQMF.dbo.MD_Object AS obj
	ON db.DatabaseId = db.DatabaseId
	WHERE 1=1
	AND db.DatabaseName = @pDatabaseNameIN
	AND obj.ObjectSchemaName = @pSchemaNameIN
	AND obj.ObjectPhysicalName = @pObjectNameIN
), Split AS (
	SELECT DISTINCT LTRIM(RTRIM(xapp.column_name)) AS column_name 
	FROM DQMF_PkField AS prev 
	CROSS APPLY 
	(
		SELECT Item AS column_name FROM dbo.strSplit(prev.ObjectPKField,'','')
	) xapp
)
SELECT @pColStrOUT = SUBSTRING((
SELECT REPLACE(''%s'', ''%s'',Split.column_name)
FROM Split
ORDER BY Split.column_name
FOR XML PATH('''')),1,10000)
'
,@pFmt,'%s')
--RAISERROR(@sql, 0, 1) WITH NOWAIT;
IF DB_ID('DQMF') IS NOT NULL
	EXEC sp_executesql @sql, @param, @pDatabaseNameIN = @pDatabaseName, @pSchemaNameIN = @pSchemaName, @pObjectNameIN = @pObjectName,@pColStrOUT = @pColStr OUTPUT 
	ELSE RAISERROR('DQMF database does not exist',0,1);
END

IF @pColStr IS NULL OR @pColStr = REPLACE(@pFmt,'%s','') OR LEN(@pColStr) = 0
BEGIN
	RAISERROR('No ObjectPKField set in DQMF.dbo.MD_Object',0,1)
	SET @param = '
	@pObjectNameIN varchar(200)
	,@pSchemaNameIN varchar(200)
	,@pColStrOUT varchar(max) OUTPUT
	'

	SET @sql = FORMATMESSAGE('
	;WITH db_obj AS (
		SELECT col.name AS column_name
		FROM %s.sys.indexes AS clu_idx
		JOIN %s.sys.index_columns AS ind_col
		ON clu_idx.index_id = ind_col.index_id
		AND clu_idx.object_id = ind_col.object_id
		JOIN %s.sys.columns AS col
		ON ind_col.object_id = col.object_id
		AND ind_col.column_id = col.column_id
		WHERE 1=1
		AND OBJECT_NAME(ind_col.object_id) = @pObjectNameIN
		AND OBJECT_SCHEMA_NAME(ind_col.object_id) = @pSchemaNameIN
		AND clu_idx.type_desc = ''CLUSTERED''
	) 
	SELECT @pColStrOUT = SUBSTRING((
	SELECT REPLACE(''%s'', ''%s'',db_obj.column_name)
	FROM db_obj
	ORDER BY db_obj.column_name
	FOR XML PATH('''')),1,10000)
'
,@pDatabaseName, @pDatabaseName, @pDatabaseName
,@pFmt,'%s')

	RAISERROR(@sql, 0, 1) WITH NOWAIT;
	PRINT @sql
	EXEC sp_executesql @sql, @param, @pSchemaNameIN = @pSchemaName, @pObjectNameIN = @pObjectName,@pColStrOUT = @pColStr OUTPUT 
END

IF @pColStr IS NULL
BEGIN
	RAISERROR('No PK is sys views',0,1)
END

	SET @pColStr = LTRIM(RTRIM(@pColStr))
	IF CHARINDEX(',',@pColStr,1) = 1
		SET @pColStr = SUBSTRING(@pColStr, 2, LEN(@pColStr))
	IF CHARINDEX(',',REVERSE(@pColStr),1) = 1
		SET @pColStr = SUBSTRING(@pColStr, 1, LEN(@pColStr)-1)
	SET @pColStr = @pColStr

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspGetKey: runtime: %i seconds(Key Columns: %s)', 0, 1, @runtime, @pColStr) WITH NOWAIT;

	RETURN(@runtime);
END TRY
BEGIN CATCH
	DECLARE @ErrorNumber int;
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorProcedure int;
	DECLARE @ErrorLine int;
	DECLARE @ErrorMessage varchar(max);
	DECLARE @UserMessage nvarchar(max);

	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorProcedure = ERROR_PROCEDURE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE()

	SET @UserMessage = FORMATMESSAGE('AutoTest proc ERROR: %s 
		Error Message: %s
		Line Number: %i
		Severity: %i
		State: %i
		Error Number: %i
	',@ErrorProcedure, @ErrorMessage, @ErrorNumber, @ErrorLine, @ErrorSeverity, @ErrorState, @ErrorNumber);

	RAISERROR(@UserMessage,0,1) WITH NOWAIT, LOG
END CATCH;
END
GO
--#endregion CREATE/ALTER PROC dbo.uspGetColumnNames

--DECLARE @pDatabaseName varchar(100) = 'CommunityMart'
--	,@pSchemaName varchar(100) = 'EMR'
--	,@pObjectName varchar(100) = 'vwAppointment'
--	,@pFmt varchar(max) = 'pre.%s,'
--	,@pColStr varchar(max)

--SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'
----SET @pSchemaName = 'dbo'
----SET @pObjectName = 'SchoolHistoryFact'
--EXEC dbo.uspGetKey 
--	@pDatabaseName
--	,@pSchemaName
--	,@pObjectName
--	,@pFmt = @pFmt
--	,@pColStr = @pColStr OUTPUT

--SELECT @pColStr
--IF @pColStr IS NULL
--BEGIN 
--	PRINT 'null';
--END


