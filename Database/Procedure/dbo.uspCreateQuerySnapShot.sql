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
	@pPkField varchar(max) = NULL, -- 
	@pDestDatabaseName varchar(100) = 'AutoTest',
	@pDestSchemaName varchar(100) = 'SnapShot',
	@pDestTableName varchar(100),
	@pIncludeIdentityPk bit = 0 -- if @pIncludeIdentityPk=0 assume pk is given by @pPkField or pk column of table/view exists and is __pkhash__  ELSE IF @pIncludeIdentityPk=1 make new ID column as pk

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	DECLARE @sql nvarchar(max)
		,@cols nvarchar(max)
		,@destFullName nvarchar(500)
		,@srcFullName nvarchar(500)
		,@IdCol nvarchar(500) = ''
	RAISERROR('    uspCreateQuerySnapShot(%s)',0,0,@pDestTableName);
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;
	
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
	',@IdCol, @pPkField, @destFullName, @pQuery)
	--RAISERROR(@sql,1,1) WITH NOWAIT;
	EXEC(@sql);
	SET @rowcount=@@ROWCOUNT;

	IF @pIncludeIdentityPk = 1
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (ID);',@pDestTableName,@destFullName);
		-- RAISERROR(@sql,1,1) WITH NOWAIT;
		EXEC(@sql);
	END
	ELSE IF EXISTS(SELECT * FROM sys.columns WHERE name = '__pkhash__' AND OBJECT_NAME(object_id) = @pDestTableName)
	BEGIN
		SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@destFullName);
		-- RAISERROR(@sql,1,1) WITH NOWAIT;
		EXEC(@sql);
	END
	ELSE
		RAISERROR('WARNING: dbo.uspCreateQuerySnapShot no clustered index will be added to snapshot. (@pPkField IS NULL AND @pIncludeIdentityPk = 0)',10,1) WITH NOWAIT;
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('    !uspCreateQuerySnapShot runtime: %i seconds (rowcount: %i)',0,1, @runtime,@rowcount) WITH NOWAIT;
	RETURN(@rowcount);
END
GO
 --EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap', @pPkField='CalendarDate',@pDestTableName='TestSnapShot'
 --EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap',@pDestTableName='TestSnapShot'
 -- EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM DSDW.BedMap.vwBedMap',@pDestTableName='TestSnapShot', @pIncludeIdentityPk = 1
 -- EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM Prod.dbo.FactSalesQuota',@pDestTableName='TestSnapShot', @pIncludeIdentityPk = 0

