--#region CREATE/ALTER PROC
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
	@pQuery nvarchar(max),
	@pPkField nvarchar(500),
	@pDestDatabaseName nvarchar(100) = 'TestLog',
	@pDestSchemaName nvarchar(100) = 'SnapShot',
	@pDestTableName nvarchar(100)
AS
BEGIN
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	RAISERROR('uspCreateQuerySnapShot',0,1) WITH NOWAIT;
	DECLARE @sql nvarchar(max)
		,@pkField varchar(500)
		,@cols nvarchar(2000)
		,@destFullName nvarchar(500)
		,@srcFullName nvarchar(500)
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;

	SELECT @pkField=FORMATMESSAGE('CHECKSUM(%s) AS __pkhash__',@pPkField)

	RAISERROR('SnapShot: QUERY -> %s',0,1, @destFullName) WITH NOWAIT;
	IF OBJECT_ID(@destFullName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', @destFullName)
		EXEC(@sql)
		RAISERROR(@sql,0,1) WITH NOWAIT;
	END

	SET @sql = FORMATMESSAGE('SELECT %s, * INTO %s FROM (%s) sub',@pkField, @destFullName, @pQuery)
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
	SET @rowcount=@@ROWCOUNT;

	SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@destFullName);
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('runtime: %i seconds (rowcount: %i)',0,1, @runtime,@rowcount) WITH NOWAIT;
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspCreateQuerySnapShot @pQuery='SELECT * FROM CommunityMart.dbo.ReferralFact', @pPkField='SourceReferralID',@pDestTableName='TestSnapShot'

