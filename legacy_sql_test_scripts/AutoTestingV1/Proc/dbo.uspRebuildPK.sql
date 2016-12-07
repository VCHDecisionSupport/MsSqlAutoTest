--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspRebuildPK';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspRebuildPK
	@pPkField nvarchar(500),
	@pDestDatabaseName nvarchar(100) = 'TestLog',
	@pDestSchemaName nvarchar(100) = 'SnapShot',
	@pDestTableName nvarchar(100)
	--@pRowCount int OUT-- = NULL
AS
BEGIN
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	DECLARE @sql nvarchar(max)
		,@param nvarchar(max)
		,@pkField varchar(500)
		,@cols nvarchar(max)
		,@destFullName nvarchar(500)
		,@srcFullName nvarchar(500)
		,@ixName nvarchar(500)
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@pDestTableName;

--	DECLARE @object_id int;
--	SELECT @object_id = OBJECT_ID(@destFullName,'U')
--	SET @param = N'@ixNameOUT nvarchar(500) OUTPUT'
--	SET @sql = FORMATMESSAGE('
--SELECT @ixNameOUT=ix.name
--FROM sys.indexes AS ix
--WHERE ix.object_id = %i
--AND ix.type_desc = ''CLUSTERED''', @object_id)
--	EXEC sp_executesql @sql, @param, @ixNameOUT = @ixName OUTPUT;

--	IF @ixName IS NOT NULL
--	BEGIN
--		SELECT @sql = FORMATMESSAGE('DROP INDEX %s ON %s;',@ixName, @destFullName)
--		EXEC(@sql);
--	END 

--	SET @sql = FORMATMESSAGE('IF EXISTS(SELECT * 
--FROM sys.columns AS col
--WHERE col.name = ''__pkhash__''
--AND col.object_id = %i)
--ALTER TABLE %s DROP COLUMN __pkhash__;', @object_id, @destFullName)
--EXEC(@sql);


--	SELECT @pkField=FORMATMESSAGE('CHECKSUM(%s) AS __pkhash__',@pPkField)
--	SET @sql = FORMATMESSAGE('ALTER TABLE %s ADD COLUMN __pkhash__ int;',@destFullName);
--	EXEC(@sql);
	SET @sql = FORMATMESSAGE( 'UPDATE %s
	SET __pkhash__ = CHECKSUM(%s)', @destFullName, @pPkField);
	EXEC(@sql);

	--SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@destFullName);
	---- RAISERROR(@sql,0,1) WITH NOWAIT;
	--EXEC(@sql);
	
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('    uspRebuildPK runtime: %i seconds (rowcount: %i)',0,1, @runtime,@rowcount) WITH NOWAIT;
END
GO
--#endregion CREATE/ALTER PROC
 --EXEC dbo.uspRebuildPK @pPkField='SourceAssessmentID',@pDestTableName='PreEtlDR123AssessmentContactFactPkgExecKey312828'

