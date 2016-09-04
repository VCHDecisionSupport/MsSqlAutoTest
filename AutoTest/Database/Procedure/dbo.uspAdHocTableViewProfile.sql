--#region CREATE/ALTER PROC dbo.uspAdHocTableViewProfile
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspAdHocTableViewProfile';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspAdHocTableViewProfile
	@pDatabaseName varchar(100)
	,@pSchemaName varchar(100)
	,@pTableName varchar(100)
	,@pObjectID int = NULL
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspAdHocTableViewProfile(%s.%s.%s)'
	RAISERROR(@fmt, 0, 1, @pDatabaseName, @pSchemaName, @pTableName) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);

	DECLARE 
		@TestTypeID int
		,@TestConfigID int
		,@PreEtlSourceObjectFullName varchar(500)
		,@PreEtlSnapShotCreationElapsedSeconds int
		,@PreEtlSnapShotName varchar(200)
		,@pPreEtlQuery nvarchar(max)
		,@TableProfileTypeID int
		,@ColumnProfileTypeID int
		,@ColumnHistogramTypeID int
		,@pObjectPkColumns varchar(500)
	
	IF @pObjectID IS NULL
	BEGIN
		SELECT @pObjectID = ObjectID
		FROM DQMF.dbo.MD_Object AS obj
		JOIN DQMF.dbo.MD_Database AS db
		ON obj.DatabaseID = db.DatabaseID
		WHERE 1=1
		AND obj.ObjectPhysicalName = @pTableName
		AND obj.ObjectSchemaName = @pSchemaName
		AND db.DatabaseName = @pDatabaseName
	END

	SELECT @TestTypeID = TestTypeID FROM AutoTest.dbo.TestType WHERE TestTypeDesc = 'AdHocDataProfile'
	SELECT @TableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'StandAloneTableProfile'
	SELECT @ColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'StandAloneColumnProfile'
	SELECT @ColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'StandAloneColumnHistogram'

	SET @PreEtlSourceObjectFullName = FORMATMESSAGE('%s.%s.%s',@pDatabaseName, @pSchemaName, @pTableName)
	
	INSERT INTO AutoTest.dbo.TestConfig (
		TestTypeID
		,PreEtlSourceObjectFullName
		,TestDate
		,ObjectID) 
	VALUES(
		@TestTypeID
		,@PreEtlSourceObjectFullName
		,GETDATE()
		,@pObjectID);
	
	SET @TestConfigID = @@IDENTITY;

	 SELECT 
	 	@PreEtlSnapShotName = PreEtlSnapShotName
	 FROM AutoTest.dbo.TestConfig tlog
	 WHERE tlog.TestConfigID = @TestConfigID

	 EXEC dbo.uspGetKey
	 	@pDatabaseName = @pDatabaseName
	 	,@pSchemaName = @pSchemaName
	 	,@pObjectName = @pTableName
	 	,@pColStr = @pObjectPkColumns OUTPUT

	 SET @pPreEtlQuery = FORMATMESSAGE(' (SELECT * FROM %s) ', @PreEtlSourceObjectFullName);

	 EXEC @PreEtlSnapShotCreationElapsedSeconds = AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @pPreEtlQuery, @pKeyColumns = @pObjectPkColumns, @pHashKeyColumns = @pObjectPkColumns, @pDestTableName = @PreEtlSnapShotName

	 UPDATE AutoTest.dbo.TestConfig 
	 SET	PreEtlSnapShotCreationElapsedSeconds = @PreEtlSnapShotCreationElapsedSeconds
	 FROM AutoTest.dbo.TestConfig tlog
	 WHERE tlog.TestConfigID = @TestConfigID

	 EXEC dbo.uspCreateProfile 
	 	@pTestConfigID = @TestConfigID,
	 	@pTargetTableName = @PreEtlSnapShotName,
	 	@pTableProfileTypeID = @TableProfileTypeID,
	 	@pColumnProfileTypeID = @ColumnProfileTypeID,
	 	@pColumnHistogramTypeID = @ColumnHistogramTypeID

	EXEC dbo.uspDropSnapShot @pTestConfigID = @TestConfigID

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspAdHocTableViewProfile: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
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
--#endregion CREATE/ALTER PROC dbo.uspAdHocTableViewProfile
--EXEC dbo.uspAdHocTableViewProfile
