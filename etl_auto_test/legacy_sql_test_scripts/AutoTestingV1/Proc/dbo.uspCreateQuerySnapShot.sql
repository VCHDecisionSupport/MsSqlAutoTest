USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateQuerySnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateQuerySnapShot
	@pQuery varchar(max) = NULL, -- assume SELECT *
	@pPkField varchar(max) = NULL, -- assume __pkhash__ exists
	@pDestDatabaseName varchar(100) = 'TestLog',
	@pDestSchemaName varchar(100) = 'SnapShot',
	@pDestTableName varchar(100),
	@pIncludeIdentityPk bit = 0

AS
BEGIN
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	DECLARE @sql nvarchar(max)
		,@cols nvarchar(max)
		,@destFullName nvarchar(500)
		,@srcFullName nvarchar(500)
		,@IdCol nvarchar(500) = ''
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;
	SELECT @pQuery = CASE WHEN @pQuery IS NULL THEN FORMATMESSAGE(' (SELECT * FROM %s) ', @destFullName) ELSE @pQuery END
	IF @pPkField IS NOT NULL
	BEGIN
		DECLARE @pFmt nvarchar(max) = '+CAST(%s AS VARCHAR)'
		SELECT @pPkField =SUBSTRING((
		SELECT REPLACE(@pFmt, '%s',item)
		FROM (
			SELECT RTRIM(LTRIM(item)) as item 
			FROM dbo.strSplit(@pPkField, ',')
		) sub
		FOR XML PATH('')),1,8000)
		SET @pPkField  = LTRIM(RTRIM(@pPkField ))
		IF CHARINDEX('+',@pPkField ,1) = 1
			SET @pPkField  = SUBSTRING(@pPkField , 2, LEN(@pPkField ))
		IF CHARINDEX('+',REVERSE(@pPkField ),1) = 1
			SET @pPkField  = SUBSTRING(@pPkField , 1, LEN(@pPkField )-1)
		SET @pPkField = FORMATMESSAGE('HASHBYTES(''MD5'', %s) AS __pkhash__,',@pPkField)
	END
	
	

	ELSE 
		SET @pPkField = ''

	IF @pIncludeIdentityPk = 1
	BEGIN
		SET @IdCol = 'ID = IDENTITY(int, 1,1),'
	END

	RAISERROR('    uspCreateQuerySnapShot: QUERY -> %s',0,1, @destFullName) WITH NOWAIT;

	IF OBJECT_ID(@destFullName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', @destFullName)
		RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
	SET @sql = FORMATMESSAGE('
	
	SELECT %s %s * 
	INTO %s 
	FROM (
	%s
	) sub',@IdCol, @pPkField, @destFullName, @pQuery)
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
	SET @rowcount=@@ROWCOUNT;

	IF @pIncludeIdentityPk = 1
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (ID);',@pDestTableName,@destFullName);
		-- RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql);
	END
	ELSE
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@destFullName);
		-- RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql);
	END
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('    uspCreateQuerySnapShot runtime: %i seconds (rowcount: %i)',0,1, @runtime,@rowcount) WITH NOWAIT;
	RETURN(@rowcount);
END
GO
 --EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap', @pPkField='CalendarDate',@pDestTableName='TestSnapShot'
 --EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap',@pDestTableName='TestSnapShot'
 EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap',@pDestTableName='TestSnapShot', @pIncludeIdentityPk = 1

