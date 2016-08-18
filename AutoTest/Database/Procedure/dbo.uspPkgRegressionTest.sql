USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspPkgRegressionTest';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspPkgRegressionTest
	@pPkgExecKey int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspPkgRegressionTest'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);

	DECLARE @TestConfigID int
		,@PreEtlSourceObjectFullName varchar(200)
		,@PostEtlSourceObjectFullName varchar(200)
		,@SnapShotBaseName varchar(200)
		,@KeyColumns varchar(500)
		,@PostEtlSnapShotCreationElapsedSeconds int
		,@PostSnapShotName varchar(200)
		,@ComparisonRuntimeSeconds int
		,@DatabaseName varchar(200)
		,@SchemaName varchar(200)
		,@TableName varchar(200)

-- INSERT INTO AutoTest.dbo.TestConfig (PreEtlSourceObjectFullName, PostEtlSourceObjectFullName, ObjectID, TestConfigID, PkgExecKey)
-- SELECT 
-- 	db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PreEtlSourceObjectFullName
-- 	,db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PostEtlSourceObjectFullName
-- 	,obj.ObjectID
-- 	,config.TestConfigID
-- 	,pkglog.PkgExecKey
-- FROM AutoTest.dbo.TestConfig AS config
-- JOIN DQMF.dbo.MD_Object AS obj
-- ON config.ObjectID = obj.ObjectID
-- JOIN DQMF.dbo.MD_Database AS db
-- ON obj.DatabaseId = db.DatabaseId
-- JOIN DQMF.dbo.AuditPkgExecution AS pkglog
-- ON config.PkgID = pkglog.PkgKey

IF (SELECT CURSOR_STATUS('global','reg_cur')) >= -1
BEGIN
	RAISERROR('reg_cur EXISTS',0,0) WITH NOWAIT
	IF (SELECT CURSOR_STATUS('global','reg_cur')) > -1
	BEGIN
		RAISERROR('reg_cur is OPEN',0,0) WITH NOWAIT
		CLOSE reg_cur
   END
DEALLOCATE reg_cur
END

DECLARE reg_cur CURSOR
FOR
SELECT 
	TestConfigID
	,PreEtlSourceObjectFullName
	,PostEtlSourceObjectFullName
	,SnapShotBaseName
FROM AutoTest.dbo.TestConfig
WHERE PkgExecKey = @pPkgExecKey

OPEN reg_cur;

FETCH NEXT FROM reg_cur INTO @TestConfigID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SnapShotBaseName = FORMATMESSAGE('TestConfigID%i',@TestConfigID);
	SELECT @PostSnapShotName = 'PostEtl_'+@SnapShotBaseName
	DECLARE @PostEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s) ', @PostEtlSourceObjectFullName);
	SET @DatabaseName = PARSENAME(@PreEtlSourceObjectFullName,3)
	SET @SchemaName = PARSENAME(@PreEtlSourceObjectFullName,2)
	SET @TableName = PARSENAME(@PreEtlSourceObjectFullName,1)
	EXEC AutoTest.dbo.uspGetKey @pDatabaseName = @DatabaseName, @pSchemaName = @SchemaName, @pObjectName = @TableName, @pColStr=@KeyColumns OUTPUT
	EXEC @PostEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @PostEtlQuery, @pKeyColumns = @KeyColumns, @pHashKeyColumns = @KeyColumns, @pDestTableName = @PostSnapShotName

	EXEC @ComparisonRuntimeSeconds = AutoTest.dbo.uspDataCompare @pTestConfigID = @TestConfigID

	UPDATE TestConfig SET
		PostEtlSnapShotCreationElapsedSeconds = @PostEtlSnapShotCreationElapsedSeconds
		,ComparisonRuntimeSeconds = @ComparisonRuntimeSeconds
	FROM TestConfig tlog
	WHERE tlog.TestConfigID = @TestConfigID

	FETCH NEXT FROM reg_cur INTO @TestConfigID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName
END



	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspPkgRegressionTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = 313071
