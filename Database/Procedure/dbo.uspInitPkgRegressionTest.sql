USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspInitPkgRegression';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspInitPkgRegression
	@pPkgExecKey int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspInitPkgRegression'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);

	DECLARE @TestConfigLogID int
		,@PreEtlSourceObjectFullName varchar(200)
		,@PostEtlSourceObjectFullName varchar(200)
		,@SnapShotBaseName varchar(200)
		,@PreEtlSnapShotCreationElapsedSeconds int
		,@PreEtlSnapShotName varchar(200)

INSERT INTO AutoTest.dbo.TestConfigLog (PreEtlSourceObjectFullName, PostEtlSourceObjectFullName, TestDate, ObjectID, TestConfigID, PkgExecKey)
SELECT 
	db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PreEtlSourceObjectFullName
	,db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PostEtlSourceObjectFullName
	,GETDATE()
	,obj.ObjectID
	,config.TestConfigID
	,pkglog.PkgExecKey
FROM AutoTest.dbo.TestConfig AS config
JOIN DQMF.dbo.MD_Object AS obj
ON config.ObjectID = obj.ObjectID
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
JOIN DQMF.dbo.AuditPkgExecution AS pkglog
ON config.PkgID = pkglog.PkgKey

DECLARE cur CURSOR
FOR
SELECT 
	TestConfigLogID
	,PreEtlSourceObjectFullName
	,PostEtlSourceObjectFullName
	,SnapShotBaseName
	,PreEtlSnapShotName
FROM AutoTest.dbo.TestConfigLog
WHERE PkgExecKey = @pPkgExecKey

OPEN cur;

FETCH NEXT FROM cur INTO @TestConfigLogID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName, @PreEtlSnapShotName

WHILE @@FETCH_STATUS = 0
BEGIN
	-- SET @SnapShotBaseName = FORMATMESSAGE('TestConfigLogID%i',@TestConfigLogID);
	-- SELECT @PreEtlSnapShotName = 'PreEtl_'+@SnapShotBaseName
	DECLARE @PreEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s) ', @PreEtlSourceObjectFullName);
	
	EXEC @PreEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @PreEtlQuery, @pDestTableName = @PreEtlSnapShotName

	UPDATE TestConfigLog SET
		PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
		,PostEtlSourceObjectFullName = @PostEtlSourceObjectFullName
		,PreEtlSnapShotCreationElapsedSeconds = @PreEtlSnapShotCreationElapsedSeconds
		-- ,SnapShotBaseName = @SnapShotBaseName
	FROM TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @TestConfigLogID

	FETCH NEXT FROM cur INTO @TestConfigLogID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName, @PreEtlSnapShotName
END

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspInitPkgRegression: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--EXEC dbo.uspInitPkgRegression
