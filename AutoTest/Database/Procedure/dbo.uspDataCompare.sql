USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspDataCompare';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO

ALTER PROC dbo.uspDataCompare
	@pTestConfigID int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	RAISERROR('uspDataCompare (TestConfigID %i)', 0, 1, @pTestConfigID) WITH NOWAIT,LOG;
	
	DECLARE @sql nvarchar(max) = ''
	DECLARE @param nvarchar(max) = ''
	
	-- set snap shot names
	DECLARE @RecordMatchRowCount int = 0;
	DECLARE @PreEtlKeyMisMatchRowCount int = 0;
	DECLARE @PostEtlKeyMisMatchRowCount int = 0;
	DECLARE @KeyMatchRowCount int = 0;
	DECLARE @PreEtlSnapShotName VARCHAR(100)
		,@PostEtlSnapShotName VARCHAR(100)
		,@RecordMatchSnapShotName VARCHAR(100)
		,@PreEtlKeyMisMatchSnapShotName VARCHAR(100)
		,@PostEtlKeyMisMatchSnapShotName VARCHAR(100)
		,@KeyMatchSnapShotName VARCHAR(100)
	-- DECLARE @SnapShotBaseName varchar(100)

	DECLARE @maxDistinctCount int = 500;


	-- get SnapShot names from calculated columns in TestConfig table
	SELECT 
		@PreEtlSnapShotName = PreEtlSnapShotName
		,@PostEtlSnapShotName = PostEtlSnapShotName
		,@RecordMatchSnapShotName = RecordMatchSnapShotName
		,@PreEtlKeyMisMatchSnapShotName = PreEtlKeyMisMatchSnapShotName
		,@PostEtlKeyMisMatchSnapShotName = PostEtlKeyMisMatchSnapShotName
		,@KeyMatchSnapShotName = KeyMatchSnapShotName
	FROM AutoTest.dbo.TestConfig tlog
	WHERE tlog.TestConfigID = @pTestConfigID



	DECLARE 
		@SnapShotDatabaseName varchar(100) = 'AutoTest'
		,@SnapShotSchemaName varchar(100) = 'SnapShot'
		,@pFmt varchar(max) = '%s,'
		,@pColStr varchar(max)
	--SET @pFmt = '
	--%s
	--%s
	--%s
	--%s
	--%s
	--%s
	--'
	SELECT @PreEtlSnapShotName
	 	,@PostEtlSnapShotName
	 	,@RecordMatchSnapShotName
	 	,@PreEtlKeyMisMatchSnapShotName
	 	,@PostEtlKeyMisMatchSnapShotName
	 	,@KeyMatchSnapShotName
	-- RAISERROR(@fmt, 0, 1,@PreEtlSnapShotName
	-- 	,@PostEtlSnapShotName
	-- 	,@RecordMatchSnapShotName
	-- 	,@PreEtlKeyMisMatchSnapShotName
	-- 	,@PostEtlKeyMisMatchSnapShotName
	-- 	,@KeyMatchSnapShotName) WITH NOWAIT;

	-- get ID values for different sub-test loggings
	DECLARE @RecordMatchTableProfileTypeID int;
	DECLARE @RecordMatchColumnProfileTypeID int;
	DECLARE @RecordMatchColumnHistogramTypeID int;
	SELECT @RecordMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'RecordMatchTableProfile'
	SELECT @RecordMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'RecordMatchColumnProfile'
	SELECT @RecordMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'RecordMatchColumnHistogram'

	DECLARE @PreEtlKeyMisMatchTableProfileTypeID int;
	DECLARE @PreEtlKeyMisMatchColumnProfileTypeID int;
	DECLARE @PreEtlKeyMisMatchColumnHistogramTypeID int;
	SELECT @PreEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PreEtlKeyMisMatchTableProfile'
	SELECT @PreEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PreEtlKeyMisMatchColumnProfile'
	SELECT @PreEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMisMatchColumnHistogram'

	DECLARE @PostEtlKeyMisMatchTableProfileTypeID int;
	DECLARE @PostEtlKeyMisMatchColumnProfileTypeID int;
	DECLARE @PostEtlKeyMisMatchColumnHistogramTypeID int;
	SELECT @PostEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PostEtlKeyMisMatchTableProfile'
	SELECT @PostEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PostEtlKeyMisMatchColumnProfile'
	SELECT @PostEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PostEtlKeyMisMatchColumnHistogram'
		
--#region Table SnapShot and Profile: Record Match (unchaged records)
	RAISERROR('      Table SnapShot and Profile: Record Match (unchaged records)',0,1) WITH NOWAIT;
	EXEC AutoTest.dbo.uspGetColumnNames 
		@pDatabaseName=@SnapShotDatabaseName
		,@pSchemaName=@SnapShotSchemaName
		,@pObjectName=@PreEtlSnapShotName
		,@pIntersectingObjectName=@PostEtlSnapShotName
		,@pFmt=@pFmt
		,@pColStr=@pColStr OUTPUT

	RAISERROR('cols: %s',0,1,@pColStr) WITH NOWAIT;
	-- nvarchar(max) too small too hold query so can't use FORMATMESSAGE; use REPLACE to keep query string in varchar(max)
	SET @sql = CAST('' AS nvarchar(max))
	SET @sql = @sql+'SELECT * 
	FROM 
	(
		SELECT 
			'+@pColStr+'
		FROM AutoTest.SnapShot.'+@PreEtlSnapShotName+'
		INTERSECT 
		SELECT 
			'+@pColStr+'
		FROM AutoTest.SnapShot.'+@PostEtlSnapShotName+'
	) gcwashere'
	--PRINT @sql
	--RAISERROR(@sql,0,1) WITH NOWAIT;
	
	EXEC @RecordMatchRowCount=AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @sql, @pKeyColumns = '__hashkey__', @pDestTableName = @RecordMatchSnapShotName
	IF @RecordMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @RecordMatchSnapShotName, @pTableProfileTypeID = @RecordMatchTableProfileTypeID, @pColumnProfileTypeID = @RecordMatchColumnProfileTypeID, @pColumnHistogramTypeID = @RecordMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      RecordMatchSnapShotName profile skipped',0,1) WITH NOWAIT;
--#endregion Record Match (unchaged records)

--#region Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)
	RAISERROR('      Table SnapShot and Profile: Pre-Etl Key MisMatch (new records)',0,1) WITH NOWAIT;
SET @pFmt = 'pre.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PreEtlSnapShotName
	,@pIntersectingObjectName=@PostEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT

	SET @sql = ''
	SET @sql = '
	SELECT 
		'+@pColStr+'
	FROM AutoTest.SnapShot.'+@PreEtlSnapShotName+' AS pre
	WHERE 1=1
	AND pre.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.'+@PostEtlSnapShotName+' AS post
	)'
	

	EXEC @PreEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pKeyColumns = '__hashkey__', @pDestTableName = @PreEtlKeyMisMatchSnapShotName
	IF @PreEtlKeyMisMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PreEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PreEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)

--#region Table SnapShot and Profile: Post-Etl Key MisMatch (new records)
	RAISERROR('      Table SnapShot and Profile: Post-Etl Key MisMatch (new records)',0,1) WITH NOWAIT;
	
	SET @pFmt = 'post.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PostEtlSnapShotName
	,@pIntersectingObjectName=@PreEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT

	SET @sql = ''
	SET @sql = '
	SELECT 
		'+@pColStr+'
	FROM AutoTest.SnapShot.'+@PostEtlSnapShotName+' AS post
	WHERE 1=1
	AND post.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.'+@PreEtlSnapShotName+' AS pre
	)'
	EXEC @PostEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pKeyColumns = '__hashkey__', @pDestTableName = @PostEtlKeyMisMatchSnapShotName
	IF @PostEtlKeyMisMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PostEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PostEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PostEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PostEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PostEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Post-Etl Key MisMatch (new records)

--#region SnapShot: Key Match
SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PreEtlSnapShotName
	,@pIntersectingObjectName=@PostEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT
	,@pSkipPkHash = 1
	--SELECT DATALENGTH(@pColStr) AS ColumnStringLength
	-- HCRSMArt Rai assessment -> 35k characters

SET @sql = FORMATMESSAGE('DROP TABLE %s;', 'SnapShot.'+@KeyMatchSnapShotName)
PRINT @sql;
IF OBJECT_ID('SnapShot.'+@KeyMatchSnapShotName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', 'SnapShot.'+@KeyMatchSnapShotName)
		RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
	RAISERROR(@KeyMatchSnapShotName,0,1) WITH NOWAIT;
--PRINT @KeyMatchSnapShotName
SET @sql = CAST(N'' AS NVARCHAR(MAX))
SET @sql = @sql + '
	SELECT 
		' + @pColStr +'
	INTO AutoTest.SnapShot.'+@KeyMatchSnapShotName+'
	FROM AutoTest.SnapShot.'+@PostEtlSnapShotName+' AS post
	INNER JOIN AutoTest.SnapShot.'+@PreEtlSnapShotName+' AS pre
	ON pre.__hashkey__=post.__hashkey__
	WHERE 1=1
	AND pre.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.'+@RecordMatchSnapShotName+' AS recordMatch
	)
	AND post.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.'+@RecordMatchSnapShotName+' AS recordMatch
	)'
	SELECT DATALENGTH(@sql) AS LEN_OF_KEY_MATCH_QUERY
	SELECT @SQL AS [processing-instruction(x)] FOR XML PATH 
	EXEC sp_executesql @stmt = @sql
	SET @KeyMatchRowCount = @@ROWCOUNT
	RAISERROR('uspDataCompare->KeyMatch snap shot created (%i rows)',0,0,@KeyMatchRowCount);

--#endregion SnapShot: Key Match

--#region TableProfile: KeyMatchProfile
IF @KeyMatchRowCount > 0
BEGIN
	DECLARE @KeyMatchTableProfileTypeID int;
	DECLARE @KeyMatchTableProfileID int;
	SELECT @KeyMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'KeyMatchTableProfile'
	SELECT @sql = FORMATMESSAGE('INSERT INTO AutoTest.dbo.TableProfile (TestConfigID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES (%i, %i, GETDATE(), %i)',@pTestConfigID, @KeyMatchRowCount, @KeyMatchTableProfileTypeID);
	EXEC(@sql);
	SET @KeyMatchTableProfileID = @@IDENTITY 
--#endregion TableProfile: KeyMatchProfile

--#region Column Profiles: Key Match Value Match/MisMatch
SET @pFmt = ',%s'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PreEtlSnapShotName
	,@pIntersectingObjectName=@PostEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT
	,@pSkipPkHash = 1


		DECLARE columnCursor CURSOR
		FOR
		SELECT 
			col_arr.Item
		FROM AutoTest.dbo.strSplit(@pColStr, ',') AS col_arr

		OPEN columnCursor;

		DECLARE @column_name nvarchar(100)

		FETCH NEXT FROM columnCursor INTO @column_name;

		DECLARE @KeyMatchValueMatchColumnProfileID int;
		DECLARE @KeyMatchValueMatchColumnProfileTypeID int;
		DECLARE @KeyMatchValueMatchColumnHistogramTypeID int;
		SELECT @KeyMatchValueMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'KeyMatchValueMatchColumnProfile'
		DECLARE @KeyMatchValueMisMatchColumnProfileID int;
		DECLARE @KeyMatchValueMisMatchColumnProfileTypeID int;
		SELECT @KeyMatchValueMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'KeyMatchValueMisMatchColumnProfile'
		
		SELECT @KeyMatchValueMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'KeyMatchValueMatchColumnHistogram'
		DECLARE @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID int;
		SELECT @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMatchValueMisMatchColumnHistogram'
		DECLARE @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID int;
		SELECT @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PostEtlKeyMatchValueMisMatchColumnHistogram'
		WHILE @@FETCH_STATUS = 0
		BEGIN
		IF OBJECT_ID('tempdb..#AutoTestTemp') IS NOT NULL
			DROP TABLE #AutoTestTemp;
		CREATE TABLE #AutoTestTemp (
			KeyMatchValueMatchColumnCount int
		);
		SET @sql = FORMATMESSAGE('
		INSERT INTO AutoTest.dbo.ColumnProfile (TableProfileID, ColumnName, ColumnCount, ColumnProfileTypeID)
		OUTPUT inserted.ColumnCount INTO #AutoTestTemp
		SELECT %i AS TableProfileID, ''%s'' AS ColumnName, COUNT(*) AS ColumnCount, %i AS ColumnProfileTypeID
		FROM AutoTest.SnapShot.%s AS merged
		WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
		', @KeyMatchTableProfileID, @column_name, @KeyMatchValueMatchColumnProfileTypeID, @KeyMatchSnapShotName, @column_name, @column_name)
		-- RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);

		--SELECT KeyMatchValueMatchColumnCount FROM #AutoTestTemp;

		SET @KeyMatchValueMatchColumnProfileID = @@IDENTITY

		INSERT INTO AutoTest.dbo.ColumnProfile (TableProfileID, ColumnName, ColumnCount, ColumnProfileTypeID) 
		SELECT @KeyMatchTableProfileID AS TableProfileID, @column_name AS ColumnName, @KeyMatchRowCount - KeyMatchValueMatchColumnCount AS ColumnCount, @KeyMatchValueMisMatchColumnProfileTypeID AS ColumnProfileTypeID
		FROM #AutoTestTemp;
		SET @KeyMatchValueMisMatchColumnProfileID = @@IDENTITY

		DECLARE @insert_count int

		
			--SELECT @column_name AS ColumnName;
			--SELECT @KeyMatchValueMisMatchColumnProfileID AS KeyMatchValueMisMatchColumnProfileID;
			--SELECT @KeyMatchValueMatchColumnProfileID AS KeyMatchValueMatchColumnProfileID;
			--SELECT @column_name AS ColumnName;
			SET @sql = FORMATMESSAGE('
			INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, [ColumnValue], ValueCount, ColumnHistogramTypeID)
			SELECT TOP %i %i AS ColumnProfileID, merged.pre_%s AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID
			FROM AutoTest.SnapShot.%s AS merged
			WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
			GROUP BY merged.pre_%s
			ORDER BY COUNT(*) DESC', @maxDistinctCount, @KeyMatchValueMatchColumnProfileID, @column_name, @KeyMatchValueMatchColumnHistogramTypeID, @KeyMatchSnapShotName, @column_name, @column_name, @column_name)
			-- RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);
			SET @insert_count = @@ROWCOUNT
			RAISERROR('KeyMatchValueMatch %s histograms rowcount %i', 0, 1, @column_name, @insert_count) WITH NOWAIT;
			
			SET @sql = FORMATMESSAGE('
			WITH valMis AS (
			SELECT merged.pre_%s, merged.post_%s
			FROM AutoTest.SnapShot.%s AS merged
			WHERE ISNULL(merged.pre_%s,-1)<>ISNULL(merged.post_%s,-1)
			), pre AS (
				SELECT TOP %i %i AS ColumnProfileID, pre_%s AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID
				FROM valMis
				GROUP BY pre_%s
				ORDER BY COUNT(*) DESC
			), post AS (
				SELECT TOP %i %i AS ColumnProfileID, post_%s AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID
				FROM valMis
				GROUP BY post_%s
				ORDER BY COUNT(*) DESC
			), both AS (
			SELECT *
			FROM pre
			UNION ALL
			SELECT *
			FROM post
			)
			INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, [ColumnValue], ValueCount, ColumnHistogramTypeID)
			SELECT *
			FROM both
			', @column_name, @column_name, @KeyMatchSnapShotName, @column_name, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name)
			--RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);
			
			SET @insert_count = @@ROWCOUNT
			--RAISERROR('KeyMatchValueMisMatch %s histograms rowcount %i', 0, 1, @column_name, @insert_count) WITH NOWAIT;

			-- EXEC dbo.uspDNE
			FETCH NEXT FROM columnCursor INTO @column_name;
		END
		CLOSE columnCursor;
		DEALLOCATE columnCursor;
	END
ELSE 
	RAISERROR('     KeyMatch profile skipped',0,1) WITH NOWAIT;
--#endregion Column Profiles: Key Match Value Match/MisMatch

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDataCompare: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
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
----dbo.uspDataCompare @pTestConfigID=25
--DECLARE 
--	@pPreEtlBaseName varchar(100) = 'SM_02_DischargeFact' + 'Adhoc'
--	,@pPostEtlBaseName varchar(100) = 'SM_03_DischargeFact' + 'Adhoc'
--	,@pTestConfigID int = 123

--SET @pPreEtlBaseName = 'FactResellerSales' + 'Adhoc'
--SET @pPostEtlBaseName = 'FactResellerSales' + 'Adhoc'
--SET @pTestConfigID = 313200

--EXEC dbo.uspDataCompare 
--	@pTestConfigID = @pTestConfigID
