USE [TestLog]
GO

USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspGetPkHash';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO

ALTER PROC [dbo].[uspGetPkHash]
	@pSourceDatabaseName varchar(100)
	,@pSourceSchemaName varchar(100)
	,@pSourceTableName varchar(100)
	,@sql nvarchar(max) OUTPUT
	,@pIntoClause nvarchar(100) = null
AS
BEGIN
	DECLARE @SourceName varchar(max) = quotename(@pSourceDatabaseName)+'.'+quotename(@pSourceSchemaName)+'.'+quotename(@pSourceTableName)
	DECLARE @pkField varchar(max), @objectID int;
	SELECT @pkField=obj.ObjectPKField, @objectID=obj.ObjectID FROM DQMF.dbo.MD_Object AS obj WHERE 1=1 AND obj.ObjectPKField IS NOT NULL AND obj.ObjectPhysicalName LIKE @pSourceTableName

	DECLARE @cols nvarchar(max);
	SELECT @cols = dbo.ufnGetColumnNames(@objectID)

	IF @pIntoClause IS NULL 
	BEGIN
		SET @sql = FORMATMESSAGE('SELECT CHECKSUM(%s) AS __pkhash__, %s FROM %s',@pkField, @cols, @SourceName)
	END
	ELSE
	BEGIN
		SET @sql = FORMATMESSAGE('SELECT CHECKSUM(%s) AS __pkhash__, %s INTO %s FROM %s',@pkField, @cols, @pIntoClause, @SourceName)
	END
END

GO


