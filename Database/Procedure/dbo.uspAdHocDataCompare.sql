USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspAdHocDataCompare';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspAdHocDataCompare
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
	SELECT @fmt='dbo.uspAdHocDataCompare'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE 
		@Prefix varchar(100)
		,@PreEtlSnapShotName varchar(200)
		,@PostEtlSnapShotName varchar(200)
		,@PreEtlSourceObjectFullName varchar(500)
		,@PostEtlSourceObjectFullName varchar(500)
		,@TestConfigLogID int
		,@SnapShotBaseName varchar(500)
		,@PreEtlSnapShotCreationElapsedSeconds int
		,@PostEtlSnapShotCreationElapsedSeconds int
		,@ComparisonRuntimeSeconds int
	
	SET @PreEtlSourceObjectFullName = FORMATMESSAGE('%s.%s.%s',@pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName)
	SET @PostEtlSourceObjectFullName = FORMATMESSAGE('%s.%s.%s',@pPostEtlDatabaseName, @pPostEtlSchemaName, @pPostEtlTableName)

	INSERT INTO TestConfigLog (PreEtlSourceObjectFullName, PostEtlSourceObjectFullName, TestDate) 
	VALUES(@PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, GETDATE());
	
	SET @TestConfigLogID = @@IDENTITY;

	-- SET @SnapShotBaseName = FORMATMESSAGE('TestConfigLogID%i',@TestConfigLogID);
	-- RAISERROR('@SnapShotBaseName=%s', 0, 1, @SnapShotBaseName) WITH NOWAIT;
	
	-- get SnapShot names from calculated columns in TestConfigLog
	SELECT 
		@PreEtlSnapShotName = PreEtlSnapShotName
		,@PostEtlSnapShotName = PostEtlSnapShotName
	FROM AutoTest.dbo.TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @TestConfigLogID

	-- create snap shots
	DECLARE @pPreEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s.%s.%s) ', @pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName);
	EXEC @PreEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @pPreEtlQuery, @pPkField = @pObjectPkColumns, @pDestTableName = @PreEtlSnapShotName
	DECLARE @pPostEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s.%s.%s) ', @pPostEtlDatabaseName, @pPostEtlSchemaName, @pPostEtlTableName);
	EXEC @PostEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @pPostEtlQuery, @pPkField = @pObjectPkColumns, @pDestTableName = @PostEtlSnapShotName

	UPDATE TestConfigLog SET
		-- SnapShotBaseName = @SnapShotBaseName
		-- ,
		PreEtlSnapShotCreationElapsedSeconds = @PreEtlSnapShotCreationElapsedSeconds
		,PostEtlSnapShotCreationElapsedSeconds = @PostEtlSnapShotCreationElapsedSeconds
	FROM AutoTest.dbo.TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @TestConfigLogID

	EXEC @ComparisonRuntimeSeconds = AutoTest.dbo.uspDataCompare @pTestConfigLogID = @TestConfigLogID

	UPDATE TestConfigLog SET
		ComparisonRuntimeSeconds = @ComparisonRuntimeSeconds
	FROM TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @TestConfigLogID

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspAdHocDataCompare: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
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
-- --SET @pPreEtlDatabaseName = 'Prod'
-- --SET @pPreEtlSchemaName = 'dbo'
-- --SET @pPreEtlTableName = 'FactResellerSales's
-- --SET @pPostEtlDatabaseName = 'Prod'
-- --SET @pPostEtlSchemaName = 'dbo'
-- --SET @pPostEtlTableName = 'FactResellerSales'
-- --SET @pObjectPkColumns = '[SalesOrderNumber], [SalesOrderLineNumber]'
-- EXEC AutoTest.dbo.uspAdHocDataCompare 
-- 	@pPreEtlDatabaseName = @pPreEtlDatabaseName
-- 	,@pPreEtlSchemaName = @pPreEtlSchemaName
-- 	,@pPreEtlTableName = @pPreEtlTableName
-- 	,@pPostEtlDatabaseName = @pPostEtlDatabaseName
-- 	,@pPostEtlSchemaName = @pPostEtlSchemaName
-- 	,@pPostEtlTableName = @pPostEtlTableName
-- 	,@pObjectPkColumns = @pObjectPkColumns
