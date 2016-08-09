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
	@pTestConfigLogID int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspDataCompare (TestConfigLogID %i)'
	RAISERROR(@fmt, 0, 1, @pTestConfigLogID) WITH NOWAIT;
	
	DECLARE @sql varchar(max);
	DECLARE @vsql varchar(max);
	DECLARE @param nvarchar(max);
	
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

	-- SELECT @SnapShotBaseName = SnapShotBaseName
	-- FROM AutoTest.dbo.TestConfigLog
	-- WHERE TestConfigLogID = @pTestConfigLogID

	DECLARE @maxDistinctCount int = 500;


-- 	DECLARE @PreEtlSnapShotName VARCHAR(100) = 'PreEtl_'+ @SnapShotBaseName
-- 	DECLARE @PostEtlSnapShotName VARCHAR(100) = 'PostEtl_'+ @SnapShotBaseName
-- 	DECLARE @RecordMatchSnapShotName VARCHAR(100) = 'RecordMatch_'+ @SnapShotBaseName
-- 	DECLARE @PreEtlKeyMisMatchSnapShotName VARCHAR(100) = 'PreEtlKeyMisMatchSnapShot_'+ @SnapShotBaseName
-- 	DECLARE @PostEtlKeyMisMatchSnapShotName VARCHAR(100) = 'PostEtlKeyMisMatchSnapShot_'+ @SnapShotBaseName
-- 	DECLARE @KeyMatchSnapShotName VARCHAR(100) = 'KeyMatch_'+ @SnapShotBaseName
-- 	SET @fmt = '
-- preEtlSnapShotName: %s
-- postEtlSnapShotName: %s
-- RecordMatchSnapShotName: %s
-- PreEtlKeyMisMatchSnapShotName: %s
-- PostEtlKeyMisMatchSnapShotName: %s
-- KeyMatchSnapShotName: %s
-- '
		-- get SnapShot names from calculated columns in TestConfigLog
	SELECT 
		@PreEtlSnapShotName = PreEtlSnapShotName
		,@PostEtlSnapShotName = PostEtlSnapShotName
		,@RecordMatchSnapShotName = RecordMatchSnapShotName
		,@PreEtlKeyMisMatchSnapShotName = PreEtlKeyMisMatchSnapShotName
		,@PostEtlKeyMisMatchSnapShotName = PostEtlKeyMisMatchSnapShotName
		,@KeyMatchSnapShotName = KeyMatchSnapShotName
	FROM AutoTest.dbo.TestConfigLog tlog
	WHERE tlog.TestConfigLogID = @pTestConfigLogID


	DECLARE 
		@SnapShotDatabaseName varchar(100) = 'AutoTest'
		,@SnapShotSchemaName varchar(100) = 'SnapShot'
		,@pFmt varchar(max) = '%s,'
		,@pColStr varchar(max)
	-- RAISERROR(@fmt, 0, 1,@PreEtlSnapShotName
	-- 	,@PostEtlSnapShotName
	-- 	,@RecordMatchSnapShotName
	-- 	,@PreEtlKeyMisMatchSnapShotName
	-- 	,@PostEtlKeyMisMatchSnapShotName
	-- 	,@KeyMatchSnapShotName) WITH NOWAIT;

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
	EXEC AutoTest.dbo.uspGetColumnNames 
		@pDatabaseName=@SnapShotDatabaseName
		,@pSchemaName=@SnapShotSchemaName
		,@pObjectName=@PreEtlSnapShotName
		,@pIntersectingObjectName=@PostEtlSnapShotName
		,@pFmt=@pFmt
		,@pColStr=@pColStr OUTPUT
	--RAISERROR('cols: %s',0,1,@pColStr) WITH NOWAIT;
	
	SET @sql = FORMATMESSAGE('
	SELECT * 
	FROM 
	(
		SELECT 
			%s
		FROM AutoTest.SnapShot.%s 
		INTERSECT 
		SELECT 
			%s
		FROM AutoTest.SnapShot.%s
	) gcwashere', @pColStr, @PreEtlSnapShotName, @pColStr, @PostEtlSnapShotName)

	EXEC @RecordMatchRowCount=AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @sql, @pKeyColumns = '__hashkey__', @pDestTableName = @RecordMatchSnapShotName
	IF @RecordMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @RecordMatchSnapShotName, @pTableProfileTypeID = @RecordMatchTableProfileTypeID, @pColumnProfileTypeID = @RecordMatchColumnProfileTypeID, @pColumnHistogramTypeID = @RecordMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      RecordMatchSnapShotName profile skipped',0,1) WITH NOWAIT;
--#endregion Record Match (unchaged records)

--#region Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)
SET @pFmt = 'pre.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PreEtlSnapShotName
	,@pIntersectingObjectName=@PostEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT

	SET @sql = FORMATMESSAGE('
	SELECT 
		%s
	FROM AutoTest.SnapShot.%s AS pre
	WHERE 1=1
	AND pre.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.%s AS post
	)', @pColStr, @PreEtlSnapShotName, @PostEtlSnapShotName)
	EXEC @PreEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pKeyColumns = '__hashkey__', @pDestTableName = @PreEtlKeyMisMatchSnapShotName
	IF @PreEtlKeyMisMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PreEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PreEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)

--#region Table SnapShot and Profile: Post-Etl Key MisMatch (new records)
	SET @pFmt = 'post.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@PreEtlSnapShotName
	,@pIntersectingObjectName=@PostEtlSnapShotName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT
SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM AutoTest.SnapShot.%s AS post
	WHERE 1=1
	AND post.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.%s AS pre
	)', @pColStr, @PostEtlSnapShotName, @PreEtlSnapShotName)
	EXEC @PostEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pKeyColumns = '__hashkey__', @pDestTableName = @PostEtlKeyMisMatchSnapShotName
	IF @PostEtlKeyMisMatchRowCount > 0
	BEGIN
		SET @param = '';
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PostEtlKeyMisMatchSnapShotName, @pTableProfileTypeID = @PostEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PostEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PostEtlKeyMisMatchColumnHistogramTypeID;
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

--SET @pColStr = FORMATMESSAGE('%s',@pColStr)
IF OBJECT_ID('AutoTest.SnapShot.'+@KeyMatchSnapShotName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', 'AutoTest.SnapShot.'+@KeyMatchSnapShotName)
		RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
SET @vsql = REPLACE('
	SELECT 
		<col> 
	INTO AutoTest.SnapShot.<merged>
	FROM AutoTest.SnapShot.<post> AS post
	INNER JOIN AutoTest.SnapShot.<pre> AS pre
	ON pre.__hashkey__=post.__hashkey__
	WHERE 1=1
	AND pre.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.<rm> AS rm
	)
	AND post.__hashkey__ NOT IN (
		SELECT __hashkey__
		FROM AutoTest.SnapShot.<rm> AS rm
	)', '<col>', @pColStr)
	SET @vsql = REPLACE(@vsql, '<merged>', CAST(@KeyMatchSnapShotName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<post>', CAST(@PostEtlSnapShotName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<pre>', CAST(@PreEtlSnapShotName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<rm>', CAST(@RecordMatchSnapShotName AS varchar(500)))
	RAISERROR(@vsql,0,1) WITH NOWAIT;
	EXEC(@vsql)
	SET @KeyMatchRowCount = @@ROWCOUNT
	RAISERROR('    uspDataCompare->KeyMatch snap shot created (%i rows)',0,0,@KeyMatchRowCount);

--#endregion SnapShot: Key Match

--#region TableProfile: KeyMatchProfile
IF @KeyMatchRowCount > 0
BEGIN
	DECLARE @KeyMatchTableProfileTypeID int;
	DECLARE @KeyMatchTableProfileID int;
	SELECT @KeyMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'KeyMatchTableProfile'
	SELECT @sql = FORMATMESSAGE('INSERT INTO AutoTest.dbo.TableProfile (TestConfigLogID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES (%i, %i, GETDATE(), %i)',@pTestConfigLogID, @KeyMatchRowCount, @KeyMatchTableProfileTypeID);
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

		
			SELECT @column_name AS ColumnName;
			SELECT @KeyMatchValueMisMatchColumnProfileID AS KeyMatchValueMisMatchColumnProfileID;
			SELECT @KeyMatchValueMatchColumnProfileID AS KeyMatchValueMatchColumnProfileID;
			SELECT @column_name AS ColumnName;
			SET @sql = FORMATMESSAGE('
			INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID)
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
			INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID)
			SELECT *
			FROM both
			', @column_name, @column_name, @KeyMatchSnapShotName, @column_name, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name)
			RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);
			
			SET @insert_count = @@ROWCOUNT
			RAISERROR('KeyMatchValueMisMatch %s histograms rowcount %i', 0, 1, @column_name, @insert_count) WITH NOWAIT;

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
END	

GO
-- DECLARE 
-- 	@pPreEtlBaseName varchar(100) = 'SM_02_DischargeFact' + 'Adhoc'
-- 	,@pPostEtlBaseName varchar(100) = 'SM_03_DischargeFact' + 'Adhoc'
-- 	,@pTestConfigLogID int = 123

-- SET @pPreEtlBaseName = 'FactResellerSales' + 'Adhoc'
-- SET @pPostEtlBaseName = 'FactResellerSales' + 'Adhoc'
-- SET @pTestConfigLogID = 11

-- EXEC dbo.uspDataCompare 
-- 	@pTestConfigLogID = @pTestConfigLogID
