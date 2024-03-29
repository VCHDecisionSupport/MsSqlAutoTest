USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspPkgRegressionTest';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
--DECLARE @pPkgExecKey int = 123;
ALTER PROC dbo.uspPkgRegressionTest
	@pPkgExecKey int
AS
BEGIN
BEGIN TRY
	--#region descrtiption
	-- called by DQMF.dbo.SetAuditPkgExecution
	--#endregion descrtiption

	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	RAISERROR('uspPkgRegressionTest(PkgExecKey %i)', 0, 1) WITH NOWAIT,LOG;
	
	DECLARE @sql nvarchar(max) = ''
	DECLARE @param nvarchar(max) = ''

	DECLARE @TestConfigID int
		,@TestTypeID int
		,@TestTypeDesc varchar(200)
		,@PreEtlSourceObjectFullName varchar(200)
		,@PostEtlSourceObjectFullName varchar(200)
		,@PreEtlSourceObjectTableName varchar(200)
		,@PostEtlSourceObjectTableName varchar(200)
		,@SnapShotBaseName varchar(200)
		,@KeyColumns varchar(500)
		,@PostEtlSnapShotCreationElapsedSeconds int
		,@TestRuntimeSeconds int
		,@DatabaseName varchar(200)
		,@SchemaName varchar(200)
		,@PreEtlSnapShotName varchar(200)
		,@PostEtlSnapShotName varchar(200)

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
	,tt.TestTypeDesc
	,PreEtlSourceObjectFullName
	,PostEtlSourceObjectFullName
	,PreEtlSnapShotName
	,PostEtlSnapShotName
FROM AutoTest.dbo.TestConfig AS config
JOIN AutoTest.dbo.TestType AS tt
ON config.TestTypeID = tt.TestTypeID
WHERE PkgExecKey = @pPkgExecKey

OPEN reg_cur;

FETCH NEXT FROM reg_cur INTO @TestConfigID, @TestTypeDesc, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @PreEtlSnapShotName, @PostEtlSnapShotName

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @TestTypeDesc IN ('RuntimeRegressionTest', 'RuntimeProfile')
	BEGIN
		SET @PostEtlSourceObjectTableName = PARSENAME(@PostEtlSourceObjectFullName,1)
		SET @PreEtlSourceObjectTableName = PARSENAME(@PreEtlSourceObjectFullName,1)
		RAISERROR('Initializing Post Etl Testing (%s on %s for TestConfigID %i)',0,1,@TestTypeDesc,@PreEtlSourceObjectTableName, @TestConfigID);
		DECLARE @PostEtlQuery nvarchar(max) = FORMATMESSAGE(' (SELECT * FROM %s) ', @PostEtlSourceObjectFullName);
		SET @DatabaseName = PARSENAME(@PreEtlSourceObjectFullName,3)
		SET @SchemaName = PARSENAME(@PreEtlSourceObjectFullName,2)
	END
	IF @TestTypeDesc IN ('RuntimeRegressionTest')
	BEGIN
		RAISERROR('Starting Post Etl Testing.',0,1,@TestTypeDesc);
		EXEC AutoTest.dbo.uspGetKey @pDatabaseName = @DatabaseName, @pSchemaName = @SchemaName, @pObjectName = @PostEtlSourceObjectTableName, @pColStr=@KeyColumns OUTPUT
		PRINT @KeyColumns;
		EXEC @PostEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @PostEtlQuery, @pKeyColumns = @KeyColumns, @pHashKeyColumns = @KeyColumns, @pDestTableName = @PostEtlSnapShotName
		EXEC @TestRuntimeSeconds = AutoTest.dbo.uspDataCompare @pTestConfigID = @TestConfigID
	END
	ELSE IF @TestTypeDesc IN ('RuntimeProfile')
	BEGIN
		DECLARE @StandAloneTableProfileTypeID int;
		DECLARE @StandAloneColumnProfileTypeID int;
		DECLARE @StandAloneColumnHistogramTypeID int;
		SELECT @StandAloneTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'StandAloneTableProfile'
		SELECT @StandAloneColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'StandAloneColumnProfile'
		SELECT @StandAloneColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'StandAloneColumnHistogram'
		EXEC @TestRuntimeSeconds = AutoTest.dbo.uspCreateProfile @pTestConfigID = @TestConfigID, @pTargetTableName = @PostEtlSnapShotName, @pTableProfileTypeID = @StandAloneTableProfileTypeID, @pColumnProfileTypeID = @StandAloneColumnProfileTypeID, @pColumnHistogramTypeID = @StandAloneColumnHistogramTypeID;
	END
	UPDATE TestConfig SET
		PostEtlSnapShotCreationElapsedSeconds = @PostEtlSnapShotCreationElapsedSeconds
		,TestRuntimeSeconds = @TestRuntimeSeconds
	FROM TestConfig tlog
	WHERE tlog.TestConfigID = @TestConfigID

	FETCH NEXT FROM reg_cur INTO @TestConfigID, @TestTypeDesc, @PreEtlSourceObjectFullName, @PostEtlSourceObjectFullName, @PreEtlSnapShotName, @PostEtlSnapShotName
END

CLOSE reg_cur;
DEALLOCATE reg_cur;


	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspPkgRegressionTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END TRY
BEGIN CATCH
	DECLARE @ErrorNumber int;
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorProcedure int;
	DECLARE @ErrorLine int;
	DECLARE @ErrorMessage varchar(max);
	DECLARE @UserMessage nvarchar(max);

	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorProcedure = ERROR_PROCEDURE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE()

	SET @UserMessage = FORMATMESSAGE('AutoTest proc ERROR: %s 
		Error Message: %s
		Line Number: %i
		Severity: %i
		State: %i
		Error Number: %i
	',@ErrorProcedure, @ErrorMessage, @ErrorNumber, @ErrorLine, @ErrorSeverity, @ErrorState, @ErrorNumber);

	RAISERROR(@UserMessage,0,1) WITH NOWAIT, LOG
END CATCH;
END
GO
--EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = 313071
