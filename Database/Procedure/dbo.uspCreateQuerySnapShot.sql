USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateQuerySnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;

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
	DECLARE @sql nvarchar(max)
		,@destFullName nvarchar(500)
		,@HashKeySql varchar(max) = ''
		,@IdColSql varchar(max) = ''
	RAISERROR('uspCreateQuerySnapShot(%s)',0,0,@pDestTableName);
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;
	
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
		SET @sql = FORMATMESSAGE('		DROP TABLE %s;', @destFullName)
		RAISERROR(@sql,1,1) WITH NOWAIT;
		EXEC(@sql)
	END

	SET @sql = FORMATMESSAGE('
		SELECT %s %s * 
		INTO %s 
		FROM (
		%s
		) sub
	',@IdColSql, @HashKeySql, @destFullName, @pQuery)

	PRINT @sql
	EXEC(@sql);



	IF @pHashKeyColumns IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxKeyHash_%s ON %s(__hashkey__);',@pDestTableName,@destFullName);
		PRINT @sql
		EXEC(@sql);
		IF @pKeyColumns IS NOT NULL
		BEGIN
			SET @sql = FORMATMESSAGE('CREATE NONCLUSTERED INDEX IxNonClustKey_%s ON %s(%s);',@pDestTableName,@destFullName,@pKeyColumns);
			PRINT @sql
			EXEC(@sql);
		END
		ELSE 
		BEGIN
			SET @sql = FORMATMESSAGE('CREATE NONCLUSTERED INDEX IxNonClustKey_%s ON %s(%s);',@pDestTableName,@destFullName,@pHashKeyColumns);
			PRINT @sql
			EXEC(@sql);
		END

	END
	ELSE IF @pKeyColumns IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxKey_%s ON %s(%s);',@pDestTableName,@destFullName,@pKeyColumns);
		PRINT @sql
		EXEC(@sql);
	END
	ELSE
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX IxId_%s ON %s (__idkey__);',@pDestTableName,@destFullName);
		PRINT @sql
		EXEC(@sql);
	END


END
GO
-- DECLARE 
-- 	@pPreEtlDatabaseName varchar(100) = 'Lien'
-- 	,@pPreEtlSchemaName varchar(100) = 'Adtc'
-- 	,@pPreEtlTableName varchar(100) = 'SM_02_DischargeFact'
-- 	,@pPostEtlDatabaseName varchar(100) = 'Lien'
-- 	,@pPostEtlSchemaName varchar(100) = 'Adtc'
-- 	,@pPostEtlTableName varchar(100) = 'SM_03_DischargeFact'
-- 	,@pObjectPkColumns varchar(100) = 'PatientID, AccountNum'
-- DECLARE @pQuery varchar(max),
-- 	@pKeyColumns varchar(max) = @pObjectPkColumns,
-- 	@pHashKeyColumns varchar(max) = @pObjectPkColumns,
-- 	@pDestDatabaseName varchar(100) = 'AutoTest',
-- 	@pDestSchemaName varchar(100) = 'SnapShot',
-- 	@pDestTableName varchar(100) = 'waldo'

-- SET @pQuery = FORMATMESSAGE('SELECT * FROM %s.%s.%s', @pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName)

-- EXEC dbo.uspCreateQuerySnapShot @pQuery=@pQuery, @pKeyColumns=@pKeyColumns, @pHashKeyColumns=@pHashKeyColumns, @pDestDatabaseName=@pDestDatabaseName,@pDestSchemaName=@pDestSchemaName,@pDestTableName=@pDestTableName
