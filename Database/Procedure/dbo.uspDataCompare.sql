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
	DECLARE @MergedKeyMatchRowCount int = 0;
	DECLARE @SnapShotBaseName varchar(100)

	SELECT @SnapShotBaseName = SnapShotBaseName
	FROM AutoTest.dbo.TestConfigLog
	WHERE TestConfigLogID = @pTestConfigLogID

	DECLARE @preEtlSnapName VARCHAR(100) = 'PreEtl_'+ @SnapShotBaseName
	DECLARE @postEtlSnapName VARCHAR(100) = 'PostEtl_'+ @SnapShotBaseName
	DECLARE @RecordMatchName VARCHAR(100) = 'RecordMatch_'+ @SnapShotBaseName
	DECLARE @PreEtlKeyMisMatchName VARCHAR(100) = 'PreEtlKeyMisMatch_'+ @SnapShotBaseName
	DECLARE @PostEtlKeyMisMatchName VARCHAR(100) = 'PostEtlKeyMisMatch_'+ @SnapShotBaseName
	DECLARE @MergedKeyMatchName VARCHAR(100) = 'KeyMatch_'+ @SnapShotBaseName
	DECLARE @maxDistinctCount int = 500;
	SET @fmt = '
preEtlSnapName: %s
postEtlSnapName: %s
RecordMatchName: %s
PreEtlKeyMisMatchName: %s
PostEtlKeyMisMatchName: %s
MergedKeyMatchName: %s
'
	
	DECLARE 
		@SnapShotDatabaseName varchar(100) = 'AutoTest'
		,@SnapShotSchemaName varchar(100) = 'SnapShot'
		,@pFmt varchar(max) = '%s,'
		,@pColStr varchar(max)
	RAISERROR(@fmt, 0, 1,@preEtlSnapName
		,@postEtlSnapName
		,@RecordMatchName
		,@PreEtlKeyMisMatchName
		,@PostEtlKeyMisMatchName
		,@MergedKeyMatchName) WITH NOWAIT;

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
		,@pObjectName=@preEtlSnapName
		,@pIntersectingObjectName=@postEtlSnapName
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
	) gcwashere', @pColStr, @preEtlSnapName, @pColStr, @postEtlSnapName)

	EXEC @RecordMatchRowCount=AutoTest.dbo.uspCreateQuerySnapShot @pQuery = @sql, @pPkField = NULL, @pDestTableName = @RecordMatchName
	IF @RecordMatchRowCount > 0
	BEGIN
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @RecordMatchName, @pTableProfileTypeID = @RecordMatchTableProfileTypeID, @pColumnProfileTypeID = @RecordMatchColumnProfileTypeID, @pColumnHistogramTypeID = @RecordMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      RecordMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Record Match (unchaged records)



--#region Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)
SET @pFmt = 'pre.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@preEtlSnapName
	,@pIntersectingObjectName=@postEtlSnapName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT

	SET @sql = FORMATMESSAGE('
	SELECT 
		%s
	FROM AutoTest.SnapShot.%s AS pre
	WHERE 1=1
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM AutoTest.SnapShot.%s AS post
	)', @pColStr, @preEtlSnapName, @postEtlSnapName)
	EXEC @PreEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pDestTableName = @PreEtlKeyMisMatchName
	IF @PreEtlKeyMisMatchRowCount > 0
	BEGIN
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PreEtlKeyMisMatchName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PreEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)





--#region Table SnapShot and Profile: Post-Etl Key MisMatch (new records)
	SET @pFmt = 'post.%s,'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@preEtlSnapName
	,@pIntersectingObjectName=@postEtlSnapName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT
SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM AutoTest.SnapShot.%s AS post
	WHERE 1=1
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM AutoTest.SnapShot.%s AS pre
	)', @pColStr, @postEtlSnapName, @preEtlSnapName)
	EXEC @PostEtlKeyMisMatchRowCount= AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@sql, @pDestTableName = @PostEtlKeyMisMatchName
	IF @PostEtlKeyMisMatchRowCount > 0
	BEGIN
		EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PostEtlKeyMisMatchName, @pTableProfileTypeID = @PostEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PostEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PostEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PostEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Post-Etl Key MisMatch (new records)

--#region SnapShot: Key Match
SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@preEtlSnapName
	,@pIntersectingObjectName=@postEtlSnapName
	,@pFmt=@pFmt
	,@pColStr=@pColStr OUTPUT
	,@pSkipPkHash = 1

--SET @pColStr = FORMATMESSAGE('%s',@pColStr)
IF OBJECT_ID('AutoTest.SnapShot.'+@MergedKeyMatchName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', 'AutoTest.SnapShot.'+@MergedKeyMatchName)
		RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
SET @vsql = REPLACE('
	SELECT 
		<col> 
	INTO AutoTest.SnapShot.<merged>
	FROM AutoTest.SnapShot.<post> AS post
	INNER JOIN AutoTest.SnapShot.<pre> AS pre
	ON pre.__pkhash__=post.__pkhash__
	WHERE 1=1
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM AutoTest.SnapShot.<rm> AS rm
	)
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM AutoTest.SnapShot.<rm> AS rm
	)', '<col>', @pColStr)
	SET @vsql = REPLACE(@vsql, '<merged>', CAST(@MergedKeyMatchName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<post>', CAST(@postEtlSnapName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<pre>', CAST(@preEtlSnapName AS varchar(500)))
	SET @vsql = REPLACE(@vsql, '<rm>', CAST(@RecordMatchName AS varchar(500)))
	RAISERROR(@vsql,0,1) WITH NOWAIT;
	EXEC(@vsql)
	SET @MergedKeyMatchRowCount = @@ROWCOUNT
	RAISERROR('    uspDataCompare->MergedKeyMatch snap shot created (%i rows)',0,0,@MergedKeyMatchRowCount);
--EXEC @MergedKeyMatchRowCount = AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@vsql, @pDestTableName = @MergedKeyMatchName, @pIncludeIdentityPk = 1

--#endregion SnapShot: Key Match


--#region TableProfile: KeyMatchProfile
IF @MergedKeyMatchRowCount > 0
BEGIN
	DECLARE @KeyMatchTableProfileTypeID int;
	DECLARE @KeyMatchTableProfileID int;
	SELECT @KeyMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'KeyMatchTableProfile'
	SELECT @sql = FORMATMESSAGE('INSERT INTO AutoTest.dbo.TableProfile (TestConfigLogID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES (%i, %i, GETDATE(), %i)',@pTestConfigLogID, @MergedKeyMatchRowCount, @KeyMatchTableProfileTypeID);
	EXEC(@sql);
	SET @KeyMatchTableProfileID = @@IDENTITY 
--#endregion TableProfile: KeyMatchProfile

--#region Column Profiles: Key Match Value Match/MisMatch
SET @pFmt = ',%s'

EXEC dbo.uspGetColumnNames 
	@pDatabaseName=@SnapShotDatabaseName
	,@pSchemaName=@SnapShotSchemaName
	,@pObjectName=@preEtlSnapName
	,@pIntersectingObjectName=@postEtlSnapName
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
		
		IF OBJECT_ID('tempdb..#AutoTestTemp') IS NOT NULL
			DROP TABLE #AutoTestTemp;
		CREATE TABLE #AutoTestTemp (
			x int
		);
		SET @sql = FORMATMESSAGE('
		INSERT INTO AutoTest.dbo.ColumnProfile (TableProfileID, ColumnName, ColumnCount, ColumnProfileTypeID)
		OUTPUT inserted.ColumnCount INTO #AutoTestTemp
		SELECT %i AS TableProfileID, ''%s'' AS ColumnName, COUNT(*) AS ColumnCount, %i AS ColumnProfileTypeID
		FROM AutoTest.SnapShot.%s AS merged
		WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
		', @KeyMatchTableProfileID, @column_name, @KeyMatchValueMatchColumnProfileTypeID, @MergedKeyMatchName, @column_name, @column_name)
		-- RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);

		SET @KeyMatchValueMatchColumnProfileID = @@IDENTITY

		INSERT INTO AutoTest.dbo.ColumnProfile (TableProfileID, ColumnName, ColumnCount, ColumnProfileTypeID) 
		SELECT TOP 1 @KeyMatchTableProfileID AS TableProfileID, @column_name AS ColumnName, @MergedKeyMatchRowCount - x AS ColumnCount, @KeyMatchValueMisMatchColumnProfileTypeID AS ColumnProfileTypeID
		FROM #AutoTestTemp;
		SET @KeyMatchValueMisMatchColumnProfileID = @@IDENTITY


		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			SET @sql = FORMATMESSAGE('
			INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID)
			SELECT TOP %i %i AS ColumnProfileID, merged.pre_%s AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID
			FROM AutoTest.SnapShot.%s AS merged
			WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
			GROUP BY merged.pre_%s
			ORDER BY COUNT(*) DESC', @maxDistinctCount, @KeyMatchValueMatchColumnProfileID, @column_name, @KeyMatchValueMatchColumnHistogramTypeID, @MergedKeyMatchName, @column_name, @column_name, @column_name)
			-- RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);
			
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
			', @column_name, @column_name, @MergedKeyMatchName, @column_name, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name)
			-- RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);

			-- EXEC dbo.uspDNE
			FETCH NEXT FROM columnCursor INTO @column_name;
		END
		CLOSE columnCursor;
		DEALLOCATE columnCursor;
	END
ELSE 
	RAISERROR('     MergedKeyMatch profile skipped',0,1) WITH NOWAIT;
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
