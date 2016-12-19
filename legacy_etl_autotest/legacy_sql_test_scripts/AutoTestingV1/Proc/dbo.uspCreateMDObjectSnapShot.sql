USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateMDObjectSnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateMdObjectSnapShot
	@pObjectID int,
	@pDestDatabaseName nvarchar(100) = 'TestLog',
	@pDestSchemaName nvarchar(100) = 'SnapShot',
	@pDestTableName nvarchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	RAISERROR('uspCreateMdObjectSnapShot ObjectID: %i',0,1, @pObjectID) WITH NOWAIT;
	DECLARE @sql nvarchar(max)
		,@pkField varchar(500)
		,@cols nvarchar(2000)
		,@destFullName nvarchar(500)
		,@srcFullName nvarchar(500)
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;

	SELECT @pkField=obj.ObjectPKField,@srcFullName=FORMATMESSAGE('%s.%s.%s',db.DatabaseName, obj.ObjectSchemaName,obj.ObjectPhysicalName) FROM DQMF.dbo.MD_Object AS obj JOIN DQMF.dbo.MD_Database db ON obj.DatabaseId = db.DatabaseId WHERE 1=1 AND ObjectID = @pObjectID;
	
	DECLARE @pFmt nvarchar(max) = '+CAST(%s AS VARCHAR)'
	DECLARE @hashPk  varchar(max) = ''
	SELECT @pkField =SUBSTRING((
	SELECT REPLACE(@pFmt, '%s',item)
	FROM (
		SELECT RTRIM(LTRIM(item)) as item 
		FROM dbo.strSplit(@pkField, ',')
	) sub
	FOR XML PATH('')),1,8000)
	SET @pkField  = LTRIM(RTRIM(@pkField ))
	IF CHARINDEX('+',@pkField ,1) = 1
		SET @pkField  = SUBSTRING(@pkField , 2, LEN(@pkField ))
	IF CHARINDEX('+',REVERSE(@pkField ),1) = 1
		SET @pkField  = SUBSTRING(@pkField , 1, LEN(@pkField )-1)
	SET @pkField = FORMATMESSAGE('HASHBYTES(''MD5'', %s) AS __pkhash__',@pkField)

	RAISERROR('SnapShot: %s -> %s',0,1,@srcFullName, @destFullName) WITH NOWAIT;
	IF OBJECT_ID(@destFullName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', @destFullName)
		-- RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END

	SELECT @cols = dbo.ufnGetColumnNames(@pObjectID,null);
	SET @sql = FORMATMESSAGE('SELECT %s, %s INTO %s FROM %s;',@pkField, @cols, @destFullName, @srcFullName)
	 RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
	SET @rowcount=@@ROWCOUNT;

	SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@destFullName);
	 RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('		uspCreateMDObjectSnapShot runtime: %i seconds (rowcount: %i)',0,1, @runtime,@rowcount) WITH NOWAIT;
	RETURN(@rowcount)
END
GO
DECLARE @rt int;
EXEC @rt = dbo.uspCreateMDObjectSnapShot @pObjectID = 53913, @pDestTableName = 'TestSnapShot'
SELECT @rt;