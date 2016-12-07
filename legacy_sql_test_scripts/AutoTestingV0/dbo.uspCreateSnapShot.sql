--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateSnapShot';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateSnapShot
	@pDestDatabaseName varchar(100)='TestLog',
	@pDestSchemaName varchar(100)='SnapShot',
	@pDestTableName varchar(100),
	@pSourceDatabaseName varchar(100),
	@pSourceSchemaName varchar(100),
	@pSourceTableName varchar(100)
AS
BEGIN
	
	DECLARE @sql varchar(MAX);

	DECLARE @DestinationName varchar(200);
	SELECT @DestinationName = quotename(@pDestDatabaseName)+'.'+quotename(@pDestSchemaName)+'.'+quotename(@pDestTableName);
	
	DECLARE @SourceName varchar(200) = quotename(@pSourceDatabaseName)+'.'+quotename(@pSourceSchemaName)+'.'+quotename(@pSourceTableName)
	RAISERROR('SnapShot: %s -> %s',0,1,@SourceName, @DestinationName) WITH NOWAIT;
	IF OBJECT_ID(@DestinationName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', @DestinationName)
		EXEC(@sql)
		RAISERROR(@sql,0,1) WITH NOWAIT;
	END

	EXEC dbo.uspGetPkHash 
		@pSourceDatabaseName = @pSourceDatabaseName,
		@pSourceSchemaName = @pSourceSchemaName,
		@pSourceTableName = @pSourceTableName,
		@sql = @sql OUTPUT,
		@pIntoClause = @DestinationName
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);

	SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (__pkhash__);',@pDestTableName,@DestinationName);
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
END
GO
--#endregion CREATE/ALTER PROC

DECLARE 	
	@pDestDatabaseName varchar(100)='TestLog',
	@pDestSchemaName varchar(100)='SnapShot',
	@pDestTableName varchar(100) = 'AssessmentContactFact',
	@pSourceDatabaseName varchar(100) = 'CommunityMart',
	@pSourceSchemaName varchar(100) = 'dbo',
	@pSourceTableName varchar(100) = 'AssessmentContactFact'
EXEC dbo.uspCreateSnapShot 
	@pDestDatabaseName = @pDestDatabaseName,
	@pDestSchemaName = @pDestSchemaName,
	@pDestTableName = @pDestTableName,
	@pSourceDatabaseName = @pSourceDatabaseName,
	@pSourceSchemaName = @pSourceSchemaName,
	@pSourceTableName = @pSourceTableName
