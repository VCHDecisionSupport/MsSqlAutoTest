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

	DECLARE @TestConfigLogID int
		,@PreEtlSourceObjectFullName varchar(200)
		,@PostEtlSourceObjectFullName varchar(200)
		,@SnapShotBaseName varchar(200)
		,@PostEtlSnapShotCreationElapsedSeconds int
		,@PostSnapShotName varchar(200)
		,@ComparisonRuntimeSeconds int

-- INSERT INTO AutoTest.dbo.TestConfigLog (PreEtlSourceObjectFullName, PostEtlSourceObjectFullName, ObjectID, TestConfigID, PkgExecKey)
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

DECLARE cur CURSOR
FOR
SELECT 
	TestConfigLogID
	,PreEtlSourceObjectFullName
	,PostEtlSourceObjectFullName
	,SnapShotBaseName
FROM AutoTest.dbo.TestConfigLog
WHERE PkgExecKey = @pPkgExecKey

OPEN cur;

FETCH NEXT FROM cur INTO @TestConfigLogID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SnapShotBaseName = FORMATMESSAGE('TestConfigLogID%i',@TestConfigLogID);
	SELECT @PostSnapShotName = 'PostEtl_'+@SnapShotBaseName
	DECLARE @PostEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s) ', @PostEtlSourceObjectFullName);
	
	EXEC @PostEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @PostEtlQuery, @pDestTableName = @PostSnapShotName

	EXEC @ComparisonRuntimeSeconds = AutoTest.dbo.uspDataCompare @pTestConfigLogID = @TestConfigLogID

	UPDATE TestConfigLog SET
		PostEtlSnapShotCreationElapsedSeconds = @PostEtlSnapShotCreationElapsedSeconds
		,ComparisonRuntimeSeconds = @ComparisonRuntimeSeconds
	FROM TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @TestConfigLogID

	FETCH NEXT FROM cur INTO @TestConfigLogID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName
END



	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspPkgRegressionTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--EXEC dbo.uspPkgRegressionTest
