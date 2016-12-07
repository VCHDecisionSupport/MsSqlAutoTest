USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspPkgExecAutoTest';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
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
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	DECLARE @pkgID INT;
	DECLARE @pkgName varchar(100);

	SELECT @pkgID = pkgExec.PkgKey
		,@pkgName = pkgExec.PkgName
	FROM DQMF.dbo.AuditPkgExecution AS pkgExec
	WHERE pkgExec.PkgExecKey = @pPkgExecKey

--#region Prepare for Snap Shot creation
	DECLARE @snapShotDataDesc VARCHAR(300);
	IF @pIsProcessStart = 1
	BEGIN
		--RAISERROR ('Populate TestConfig table from DataRequestTestConfig', 0, 1) WITH NOWAIT;
		EXEC TestLog.dbo.uspInsTestConfig @pPkgId = @pkgId, @pPkgExecKey = @pPkgExecKey
		SELECT @snapShotDataDesc = 'PreEtl'
	END
	ELSE IF @pIsProcessStart = 0
	BEGIN
		SELECT @snapShotDataDesc = 'PostEtl'
	END
--#endregion Prepare for snapshot creation
	
--#region Create SnapShot
	BEGIN
		DECLARE cur CURSOR
		FOR
		SELECT DISTINCT db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName, obj.ObjectID, config.TestConfigID, config.DataRequestID, config.PkgID
		FROM TestLog.dbo.TestConfig AS config
		INNER JOIN DQMF.dbo.MD_Object AS obj
			ON config.ObjectID = obj.ObjectID
		INNER JOIN DQMF.dbo.MD_Database AS db
			ON obj.DatabaseId = db.DatabaseId
		WHERE PkgExecKey = @pPkgExecKey;
		DECLARE @databaseName VARCHAR(100), @schemaName VARCHAR(100), @tableName VARCHAR(100), @objectID INT, @testConfigID INT, @dataRequestID INT, @tableProfileID INT, @snapShotName VARCHAR(100);
		OPEN cur;
		FETCH NEXT
		FROM cur
		INTO @databaseName, @schemaName, @tableName, @objectID, @testConfigID, @dataRequestID, @pkgID;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			RAISERROR ('Making SnapShot: %s.%s.%s
			', 0, 1, @databaseName, @schemaName, @tableName)
			WITH NOWAIT;
			EXEC DQMF.dbo.SetMDObjectAttribute @pObjectID = @objectID
			SELECT @snapShotName = TestLog.dbo.ufnGetSnapShotName(@snapShotDataDesc, @dataRequestID, @tableName, @pPkgExecKey, NULL);
			EXEC TestLog.dbo.uspCreateMDObjectSnapShot @pObjectID = @objectID, @pDestTableName = @snapShotName;
			

			FETCH NEXT
			FROM cur
			INTO @databaseName, @schemaName, @tableName, @objectID, @testConfigID, @dataRequestID, @pkgID;
		END
		CLOSE cur;
		DEALLOCATE cur;
	END
--#endregion Create SnapShot
	
--#region Do Regression Test
	IF @pIsProcessStart = 0
	BEGIN
		EXEC TestLog.dbo.uspRegressionTest @pPkgExecKey, @testConfigID, @dataRequestID, @objectID
		RAISERROR ('uspRegressionTest complete.', 0, 1);
	END
--#endregion Do Regression Test


	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspPkgExecAutoTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
