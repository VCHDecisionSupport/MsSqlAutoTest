USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateQuerySnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 1) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO

ALTER PROC dbo.uspCreateQuerySnapShot
	@pQuery varchar(max),
	@pKeyColumns varchar(max) = NULL,
	@pHashKeyColumns varchar(max) = NULL,
	@pDestDatabaseName varchar(100) = 'AutoTest',
	@pDestSchemaName varchar(100) = 'SnapShot',
	@pDestTableName varchar(100)
AS 
BEGIN
-- if @pHashKeyColumns is not null AND @pKeyColumns is not null
-- 	- make __keyhash__ column using HASHBYTES
-- 	- put CLUTERED index on __keyhash__ column
-- 	- put NONCLUTERED index on @pKeyColumns column(s)

-- if @pHashKeyColumns is not null AND @pKeyColumns is null
-- 	- make __keyhash__ column using HASHBYTES
-- 	- put CLUTERED index on __keyhash__ column

-- if @pHashKeyColumns is null AND @pKeyColumns is not null
-- 	- put CLUTERED index on @pKeyColumns column(s)

-- if @pHashKeyColumns is null AND @pKeyColumns is null AND __hashkey__ column exists then
-- 	- put CLUTERED index on __keyhash__ column

-- if @pHashKeyColumns is null AND @pKeyColumns is null AND __hashkey__ column does not exists then
-- 	- make __idkey__ column using IDENTITY(1,1)
-- 	- put CLUTERED index on __idkey__ column

	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	DECLARE @sql nvarchar(max) = ''
		,@destFullName nvarchar(500)
		,@HashKeySql varchar(max) = ''
		,@IdColSql varchar(max) = ''
	RAISERROR('uspCreateQuerySnapShot(%s, @pKeyColumns=%s; @pHashKeyColumns=%s)',0,0,@pDestTableName, @pKeyColumns, @pHashKeyColumns);
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;
	SELECT CAST('<root><![CDATA[' + @pQuery + ']]></root>' AS XML)
	DECLARE @pFmt nvarchar(max) = '+ISNULL(CAST(#column_name# AS VARCHAR),''__null__'')'

	IF @pHashKeyColumns IS NOT NULL
	BEGIN
		SELECT @HashKeySql=
			SUBSTRING(
				(
					SELECT item AS [text()]
					FROM (
						SELECT REPLACE(@pFmt, '#column_name#', RTRIM(LTRIM(item))) AS item
						FROM dbo.strSplit(@pHashKeyColumns, ',')
					) sub
					FOR XML PATH('')
				),2,8000)
		SET @HashKeySql  = LTRIM(RTRIM(@HashKeySql ))
		IF CHARINDEX('+',@HashKeySql ,1) = 1
			SET @HashKeySql  = SUBSTRING(@HashKeySql , 2, LEN(@HashKeySql ))
		IF CHARINDEX('+',REVERSE(@HashKeySql ),1) = 1
			SET @HashKeySql  = SUBSTRING(@HashKeySql , 1, LEN(@HashKeySql )-1)
		SET @HashKeySql = FORMATMESSAGE('HASHBYTES(''MD5'', %s) AS __hashkey__,',@HashKeySql)
	END
	IF @pKeyColumns IS NULL
	BEGIN
		SET @IdColSql = '__idkey__ = IDENTITY(int, 1,1),'
	END

	IF OBJECT_ID(@destFullName,'U') IS NOT NULL
	BEGIN
		SET @sql = 'DROP TABLE '+@destFullName;
		--RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
	
	SET @sql = ''
	SET @sql = @sql+'
		SELECT '+@IdColSql+' '+@HashKeySql+' * 
		INTO '+@destFullName+' 
		FROM (
		'+@pQuery+'
		) sub
	'
	--PRINT @sql
	SELECT CAST('<root><![CDATA[' + @sql + ']]></root>' AS XML) AS SnapShotQuery

	EXEC sp_executesql @stmt = @sql
	SET @rowcount = @@ROWCOUNT;

	IF OBJECT_ID(@pDestTableName,'U') IS NULL AND @rowcount = 0
	BEGIN
		RAISERROR('ERROR: %s not created',0,1,@pDestTableName) WITH NOWAIT;
	END


	IF @pHashKeyColumns IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxAutoTestHash_%s ON %s(__hashkey__);',@pDestTableName,@destFullName);
		-- SET @sql = FORMATMESSAGE('ALTER TABLE %s ADD CONSTRAINT IxAutoTestHash_%s PRIMARY KEY CLUSTERED (__hashkey__);',@pDestTableName,@destFullName);
		--PRINT @sql
		EXEC(@sql);
		IF @pKeyColumns IS NOT NULL
		BEGIN
			SET @sql = FORMATMESSAGE('CREATE NONCLUSTERED INDEX IxNonClustKey_%s ON %s(%s);',@pDestTableName,@destFullName,@pKeyColumns);
			--PRINT @sql
			EXEC(@sql);
		END
		ELSE 
		BEGIN
			SET @sql = FORMATMESSAGE('CREATE NONCLUSTERED INDEX IxNonClustKey_%s ON %s(%s);',@pDestTableName,@destFullName,@pHashKeyColumns);
			--PRINT @sql
			EXEC(@sql);
		END

	END
	ELSE IF @pKeyColumns IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxAutoTest_%s ON %s(%s);',@pDestTableName,@destFullName,@pKeyColumns);
		-- SET @sql = FORMATMESSAGE('ALTER TABLE %s ADD CONSTRAINT IxAutoTestHash_%s PRIMARY KEY CLUSTERED (%s);',@destFullName,@pDestTableName,@pKeyColumns);
		--PRINT @sql
		EXEC(@sql);
	END
	ELSE
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxAutoTestHash_%s ON %s (__idkey__);',@pDestTableName,@destFullName);
		-- SET @sql = FORMATMESSAGE('ALTER TABLE %s ADD CONSTRAINT IxAutoTestHash_%s PRIMARY KEY CLUSTERED (__idkey__);',@destFullName,@pDestTableName);
		--PRINT @sql
		EXEC(@sql);
	END

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspCreateQuerySnapShot: runtime: %i seconds (rowcount: %i)', 0, 1, @runtime, @rowcount) WITH NOWAIT;
	RETURN(@runtime);

END
GO
