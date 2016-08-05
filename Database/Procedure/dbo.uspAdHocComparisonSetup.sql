--#region CREATE/ALTER PROC dbo.uspAdHocComparisonSetup
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspAdHocComparisonSetup';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspAdHocComparisonSetup
	@pPreEtlDatabaseName varchar(100)
	,@pPreEtlSchemaName varchar(100)
	,@pPreEtlTableName varchar(100)
	,@pPostEtlDatabaseName varchar(100)
	,@pPostEtlSchemaName varchar(100)
	,@pPostEtlTableName varchar(100)
	,@pObjectPkColumns varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspAdHocComparisonSetup'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE 
		@pPrefix varchar(100)
		,@preSnapShotDataDesc varchar(200)
		,@postSnapShotDataDesc varchar(200)
		,@preSnapShotName varchar(200)
		,@postSnapShotName varchar(200)

	-- set snap shot names
	SELECT @pPrefix = 'PreEtl_'
	SELECT @preSnapShotName=dbo.ufnGetSnapShotName(@pPrefix, NULL, @pPreEtlTableName, NULL, NULL)
	SELECT @pPrefix = 'PostEtl_'
	SELECT @postSnapShotName=dbo.ufnGetSnapShotName(@pPrefix, NULL, @pPostEtlTableName, NULL, NULL)

	-- create snap shots
	DECLARE @pPreEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s.%s.%s) ', @pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName);
	EXEC AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @pPreEtlQuery, @pPkField = @pObjectPkColumns, @pDestTableName = @preSnapShotName
	DECLARE @pPostEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s.%s.%s) ', @pPostEtlDatabaseName, @pPostEtlSchemaName, @pPostEtlTableName);
	EXEC AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @pPostEtlQuery, @pPkField = @pObjectPkColumns, @pDestTableName = @postSnapShotName

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDataCompare: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspAdHocComparisonSetup
DECLARE 
	@pPreEtlDatabaseName varchar(100) = 'Lien'
	,@pPreEtlSchemaName varchar(100) = 'Adtc'
	,@pPreEtlTableName varchar(100) = 'SM_02_DischargeFact'
	,@pPostEtlDatabaseName varchar(100) = 'Lien'
	,@pPostEtlSchemaName varchar(100) = 'Adtc'
	,@pPostEtlTableName varchar(100) = 'SM_03_DischargeFact'
	,@pObjectPkColumns varchar(100) = 'PatientID, AccountNum'
SET @pPreEtlDatabaseName = 'Prod'
SET @pPreEtlSchemaName = 'dbo'
SET @pPreEtlTableName = 'FactResellerSales'
SET @pPostEtlDatabaseName = 'Prod'
SET @pPostEtlSchemaName = 'dbo'
SET @pPostEtlTableName = 'FactResellerSales'
SET @pObjectPkColumns = '[SalesOrderNumber], [SalesOrderLineNumber]'
EXEC dbo.uspAdHocComparisonSetup 
	@pPreEtlDatabaseName = @pPreEtlDatabaseName
	,@pPreEtlSchemaName = @pPreEtlSchemaName
	,@pPreEtlTableName = @pPreEtlTableName
	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
	,@pPostEtlSchemaName = @pPostEtlSchemaName
	,@pPostEtlTableName = @pPostEtlTableName
	,@pObjectPkColumns = @pObjectPkColumns
