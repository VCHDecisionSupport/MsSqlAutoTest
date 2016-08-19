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
	SELECT @pPkgExecKey AS PkgExecKey
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @rowcount int;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspInitPkgRegression(PkgExecKey=%i)'
	RAISERROR(@fmt, 0, 1, @pPkgExecKey) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);

	DECLARE 
		@TableCount int = 0
		,@TestConfigID int
		,@PreEtlSourceObjectFullName varchar(200)
		,@PostEtlSourceObjectFullName varchar(200)
		,@SnapShotBaseName varchar(200)
		,@KeyColumns varchar(500)
		,@PreEtlSnapShotCreationElapsedSeconds int
		,@PreEtlSnapShotName varchar(200)
		,@DatabaseName varchar(200)
		,@SchemaName varchar(200)
		,@TableName varchar(200)

-- setup regression test specs: copy configurations from AutoTest.dbo.TestConfig: insert into AutoTest.dbo.TestConfig
INSERT INTO AutoTest.dbo.TestConfig (TestTypeID, PreEtlSourceObjectFullName, PostEtlSourceObjectFullName, TestDate, ObjectID, PkgExecKey)
SELECT 
	pgkobj.TestTypeID
	,db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PreEtlSourceObjectFullName
	,db.DatabaseName +'.'+obj.ObjectSchemaName+'.'+obj.ObjectPhysicalName AS PostEtlSourceObjectFullName
	,GETDATE()
	,obj.ObjectID
	,pkglog.PkgExecKey
FROM DQMF.dbo.ETL_PackageObject AS pgkobj
JOIN DQMF.dbo.MD_Object AS obj
ON pgkobj.ObjectID = obj.ObjectID
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
JOIN DQMF.dbo.AuditPkgExecution AS pkglog
ON pgkobj.PackageID = pkglog.PkgKey
WHERE 1=1
AND obj.IsActive = 1
AND obj.IsObjectInDB = 1
AND obj.ObjectPurpose = 'Fact'
AND pkglog.PkgExecKey = @pPkgExecKey

SET @TableCount = @@ROWCOUNT;
SET @TestConfigID = @@IDENTITY;

DECLARE cur CURSOR
FOR
SELECT 
	TestConfigID
	,PreEtlSourceObjectFullName
	,PostEtlSourceObjectFullName
	,SnapShotBaseName
	,PreEtlSnapShotName
FROM AutoTest.dbo.TestConfig
WHERE PkgExecKey = @pPkgExecKey

OPEN cur;

FETCH NEXT FROM cur INTO @TestConfigID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName, @PreEtlSnapShotName

WHILE @@FETCH_STATUS = 0
BEGIN
	-- SET @SnapShotBaseName = FORMATMESSAGE('TestConfigID%i',@TestConfigID);
	-- SELECT @PreEtlSnapShotName = 'PreEtl_'+@SnapShotBaseName
	DECLARE @PreEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s) ', @PreEtlSourceObjectFullName);
	SET @DatabaseName = PARSENAME(@PreEtlSourceObjectFullName,3)
	SET @SchemaName = PARSENAME(@PreEtlSourceObjectFullName,2)
	SET @TableName = PARSENAME(@PreEtlSourceObjectFullName,1)
	EXEC AutoTest.dbo.uspGetKey @pDatabaseName = @DatabaseName, @pSchemaName = @SchemaName, @pObjectName = @TableName, @pColStr=@KeyColumns OUTPUT
	EXEC @PreEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @PreEtlQuery, @pKeyColumns = @KeyColumns, @pHashKeyColumns = @KeyColumns, @pDestTableName = @PreEtlSnapShotName

	UPDATE TestConfig SET
		PreEtlSourceObjectFullName = @PreEtlSourceObjectFullName
		,PostEtlSourceObjectFullName = @PostEtlSourceObjectFullName
		,PreEtlSnapShotCreationElapsedSeconds = @PreEtlSnapShotCreationElapsedSeconds
		-- ,SnapShotBaseName = @SnapShotBaseName
	FROM AutoTest.dbo.TestConfig tlog
	WHERE tlog.TestConfigID = @TestConfigID

	FETCH NEXT FROM cur INTO @TestConfigID, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @SnapShotBaseName, @PreEtlSnapShotName
	SET @TableCount = @TableCount + 1;
END

CLOSE cur;
DEALLOCATE cur;

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspInitPkgRegression: runtime: %i seconds (%i will configured for testing)', 0, 1, @runtime, @TableCount) WITH NOWAIT;
	RETURN(@runtime);
END
GO
