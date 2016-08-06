USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspPkgExecAutoTest';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;	

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspPkgExecAutoTest
	@pPkgExecKey int
	,@pIsProcessStart bit
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspPkgExecAutoTest'
	RAISERROR(@fmt,1,1) WITH NOWAIT;
	
	DECLARE @sql varchar(max);
	DECLARE @param varchar(max);
	
	DECLARE @pkgID INT
		,@pkgName varchar(100)
		,@pPreEtlSnapShotPrefix varchar(100) = 'PreEtl_'
		,@pPostEtlSnapShotPrefix varchar(100) = 'PostEtl_'
		,@PreEtlBaseName varchar(500)
		,@PostEtlBaseName varchar(500)
		,@snapShotDataDesc VARCHAR(300)


	SELECT @pkgID = pkgExec.PkgKey
		,@pkgName = pkgExec.PkgName
	FROM DQMF.dbo.AuditPkgExecution AS pkgExec
	WHERE pkgExec.PkgExecKey = @pPkgExecKey

--#region Set SnapShot Prefix, Save TestConfigLog specs (one record for each pre vs post comparison)
	IF @pIsProcessStart = 1
	BEGIN
		RAISERROR ('Populate TestConfigLog table from DataRequestTestConfig', 0, 1) WITH NOWAIT;
		SELECT @snapShotDataDesc = 'PreEtl'
		EXEC AutoTest.dbo.uspInsTestConfigLog @pPkgId = @pkgId, @pPkgExecKey = @pPkgExecKey
	END
	ELSE IF @pIsProcessStart = 0
	BEGIN
		SELECT @snapShotDataDesc = 'PostEtl'
	END
--#endregion Set SnapShot Prefix, Save TestConfigLog specs (one record for each pre vs post comparison)
	
--#region Create SnapShot
	BEGIN
		DECLARE cur CURSOR
		FOR
		SELECT DISTINCT db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName, obj.ObjectID, config.TestConfigLogID, config.DataRequestID, config.PkgID
		FROM AutoTest.dbo.TestConfigLog AS config
		INNER JOIN DQMF.dbo.MD_Object AS obj
			ON config.ObjectID = obj.ObjectID
		INNER JOIN DQMF.dbo.MD_Database AS db
			ON obj.DatabaseId = db.DatabaseId
		WHERE PkgExecKey = @pPkgExecKey;
		DECLARE @databaseName VARCHAR(100), @schemaName VARCHAR(100), @tableName VARCHAR(100), @objectID INT, @TestConfigLogID INT, @dataRequestID INT, @tableProfileID INT, @snapShotName VARCHAR(100);
		OPEN cur;
		FETCH NEXT
		FROM cur
		INTO @databaseName, @schemaName, @tableName, @objectID, @TestConfigLogID, @dataRequestID, @pkgID;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			RAISERROR ('Making SnapShot: %s.%s.%s ', 0, 1, @databaseName, @schemaName, @tableName) WITH NOWAIT;
			EXEC DQMF.dbo.SetMDObjectAttribute @pObjectID = @objectID
			EXEC DQMF.dbo.SetMDObject
			SELECT @snapShotName = AutoTest.dbo.ufnGetSnapShotName(@snapShotDataDesc, @dataRequestID, @tableName, @pPkgExecKey, NULL);
			SET @sql = 'SELECT * FROM <database>.<schema>.<table>'
			SET @sql = REPLACE(@sql, '<database>', @databaseName)
			SET @sql = REPLACE(@sql, '<schema>', @schemaName)
			SET @sql = REPLACE(@sql, '<table>', @tableName)
			DECLARE @pkCols varchar(100);
			EXEC AutoTest.dbo.uspGetKey @pDatabaseName = @databaseName, @pSchemaName = @schemaName, @pObjectName = @tableName, @pColStr = @pkCols OUTPUT
			EXEC AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @sql, @pPkField=@pkCols, @pDestTableName = @snapShotName;
			
--#region Do Regression Test
		IF @pIsProcessStart = 0
		BEGIN
			SELECT @PreEtlBaseName = AutoTest.dbo.ufnGetSnapShotName('', @dataRequestID, @tableName, @pPkgExecKey, NULL);
			SELECT @PostEtlBaseName = AutoTest.dbo.ufnGetSnapShotName('', @dataRequestID, @tableName, @pPkgExecKey, NULL);
			
			EXEC AutoTest.dbo.uspDataCompare @pPreEtlBaseName = @PreEtlBaseName, @pPostEtlBaseName = @PostEtlBaseName, @pTestConfigLogID = @TestConfigLogID
			RAISERROR ('Regression Test complete.', 0, 1);
		END
--#endregion Do Regression Test


			FETCH NEXT
			FROM cur
			INTO @databaseName, @schemaName, @tableName, @objectID, @TestConfigLogID, @dataRequestID, @pkgID;
		END
		CLOSE cur;
		DEALLOCATE cur;
	END
--#endregion Create SnapShot
	



	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspPkgExecAutoTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
