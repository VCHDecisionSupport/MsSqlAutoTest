--#region diff maker loop
DECLARE @PkgExecKey int = ?

DECLARE diffCursor CURSOR
FOR
SELECT PreEtlSnapShotName
FROM DQMF.dbo.AuditPkgExecution AS pkglog
JOIN AutoTest.dbo.TestConfig AS tlog
ON pkglog.PkgExecKey = tlog.PkgExecKey
WHERE 1=1
AND tlog.PkgExecKey=@PkgExecKey


OPEN diffCursor;

DECLARE @RC int
DECLARE @pDatabaseName nvarchar(200) = 'AutoTest'
DECLARE @pSchemaName nvarchar(200) = 'SnapShot'
DECLARE @pObjectName nvarchar(200) = 'SchoolHistoryFact'
DECLARE @pPercentError int

FETCH NEXT FROM diffCursor INTO @pObjectName

-- TODO: Set parameter values here.
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @pDatabaseName;
	PRINT @pSchemaName;
	PRINT @pObjectName;

	EXECUTE @RC = AutoTest.[dbo].[uspDiffMaker] 
	   @pDatabaseName
	  ,@pSchemaName
	  ,@pObjectName
	  ,@pPercentError
	FETCH NEXT FROM diffCursor INTO @pObjectName

END

CLOSE diffCursor
DEALLOCATE diffCursor;
--#endregion diff maker loop
