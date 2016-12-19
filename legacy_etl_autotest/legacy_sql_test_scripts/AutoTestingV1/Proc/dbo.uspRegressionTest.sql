USE TestLog
GO
SET NOCOUNT ON;

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspRegressionTest';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS one END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspRegressionTest
	@pPkgExecKey int
	,@pTestConfigID int
	,@pDataRequestID int = NULL
	,@pObjectID int = NULL
	,@pPreEtlObjectNameBase nvarchar(200)
	,@pPostEtlObjectNameBase nvarchar(200)
AS
BEGIN
--#region Initialization
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt=REPLICATE(char(13), 4)+'  uspRegressionTest: ObjectID: %i (PkgExecKey: %i)'
	RAISERROR(@fmt, 0, 1, @pObjectID, @pPkgExecKey) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	DECLARE @rowcount int = 0;
	DECLARE @databaseName nvarchar(200);
	DECLARE @schemaName nvarchar(200);
	DECLARE @tableName nvarchar(200);

	
	SELECT 
		@databaseName=db.DatabaseName
		,@schemaName=obj.ObjectSchemaName
		,@tableName=obj.ObjectPhysicalName
		-- ,config.PkgID
	FROM TestLog.dbo.TestConfig AS config
	INNER JOIN DQMF.dbo.MD_Object AS obj
	ON config.ObjectID = obj.ObjectID
	INNER JOIN DQMF.dbo.MD_Database AS db
	ON obj.DatabaseId = db.DatabaseId
	WHERE PkgExecKey = @pPkgExecKey
	AND config.ObjectID = @pObjectID

	IF @tableName IS NULL
	BEGIN
		RAISERROR ('  ERROR!!!: INVALID PkgExecKey', 0, 1)  WITH NOWAIT;
		RETURN(1)
	END
	-- get snapshot table names...
	RAISERROR ('  --@preEtlSnapName = %s', 0, 1, @preEtlSnapName);
	RAISERROR ('  --@postEtlSnapName = %s', 0, 1, @postEtlSnapName);
	
	DECLARE @RecordMatchNameRowCount int = 0;
	DECLARE @PreEtlKeyMisMatchNameRowCount int = 0;
	DECLARE @PostEtlKeyMisMatchNameRowCount int = 0;
	DECLARE @preEtlSnapName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PreEtl', @pDataRequestID, @tableName, @pPkgExecKey, NULL)
	DECLARE @postEtlSnapName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PostEtl', @pDataRequestID, @tableName, @pPkgExecKey, NULL)
	DECLARE @RecordMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('RecordMatch', @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	DECLARE @PreEtlKeyMisMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PreEtlKeyMisMatch', @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	DECLARE @PostEtlKeyMisMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PostEtlKeyMisMatch', @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	DECLARE @MergedKeyMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('KeyMatch', @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	
	DECLARE @cols VARCHAR(max) = ''
	DECLARE @TableProfileTypeID int;
--#endregion Initialization
	
--#region Table SnapShot and Profile: Record Match (unchaged records)
	SELECT @TableProfileTypeID = TableProfileTypeID FROM TestLog.dbo.TableProfileType WHERE TableProfileTypeDesc = 'RecordMatchProfile'
	
	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,null)
	DECLARE @pkField NVARCHAR(200);
	SELECT @pkField = obj.ObjectPKField
	FROM DQMF.dbo.MD_Object AS obj
	WHERE 1 = 1
	AND ObjectID = @pObjectID;
	SET @sql = FORMATMESSAGE('
	SELECT %s FROM 
		(
		SELECT 
			__pkhash__, %s 
		FROM TestLog.SnapShot.%s 
		INTERSECT 
		SELECT 
			__pkhash__, %s 
		FROM TestLog.SnapShot.%s
	) gcwashere', @cols, @cols, @preEtlSnapName, @cols, @postEtlSnapName)
		RAISERROR(@pkField,0,1) WITH NOWAIT;

	EXEC @RecordMatchNameRowCount=TestLog.dbo.uspCreateQuerySnapShot @sql, @pPkField = @pkField, @pDestTableName = @RecordMatchName
	IF @RecordMatchNameRowCount > 0
	BEGIN
		DECLARE @RecordMatchTableProfileTypeID int;
		DECLARE @RecordMatchColumnProfileTypeID int;
		DECLARE @RecordMatchColumnHistogramTypeID int;
		SELECT @RecordMatchTableProfileTypeID = TableProfileTypeID FROM TestLog.dbo.TableProfileType WHERE TableProfileTypeDesc = 'RecordMatchTableProfile'
		SELECT @RecordMatchColumnProfileTypeID = ColumnProfileTypeID FROM TestLog.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'RecordMatchColumnProfile'
		SELECT @RecordMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'RecordMatchColumnHistogram'
		EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @RecordMatchName, @pTableProfileTypeID = @RecordMatchTableProfileTypeID, @pColumnProfileTypeID = @RecordMatchColumnProfileTypeID, @pColumnHistogramTypeID = @RecordMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      RecordMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Record Match (unchaged records)

--#region Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)
	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,',pre.%s')
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS pre
	FULL JOIN TestLog.SnapShot.%s AS rm
	ON pre.__pkhash__=rm.__pkhash__
	FULL JOIN TestLog.SnapShot.%s AS post
	ON pre.__pkhash__=post.__pkhash__
	WHERE post.__pkhash__ IS NULL
	AND rm.__pkhash__ IS NULL', @cols, @preEtlSnapName, @RecordMatchName, @postEtlSnapName)
	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,',%s')
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS pre
	WHERE 1=1
	--AND pre.__pkhash__ NOT IN (
	--	SELECT __pkhash__
	--	FROM TestLog.SnapShot.%s AS rm
	--)
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS post
	)', @cols, @preEtlSnapName, @RecordMatchName, @postEtlSnapName)
	EXEC @PreEtlKeyMisMatchNameRowCount= TestLog.dbo.uspCreateQuerySnapShot @sql, @pPkField = @pkField, @pDestTableName = @PreEtlKeyMisMatchName
	IF @PreEtlKeyMisMatchNameRowCount > 0
	BEGIN
		DECLARE @PreEtlKeyMisMatchTableProfileTypeID int;
		DECLARE @PreEtlKeyMisMatchColumnProfileTypeID int;
		DECLARE @PreEtlKeyMisMatchColumnHistogramTypeID int;
		SELECT @PreEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM TestLog.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PreEtlKeyMisMatchTableProfile'
		SELECT @PreEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM TestLog.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PreEtlKeyMisMatchColumnProfile'
		SELECT @PreEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMisMatchColumnHistogram'
		EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PreEtlKeyMisMatchName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PreEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Pre-Etl Key MisMatch (deleted)

--#region Table SnapShot and Profile: Post-Etl Key MisMatch (new records)
	SELECT @TableProfileTypeID = TableProfileTypeID FROM TestLog.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PostEtlKeyMisMatchProfile'
	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,',post.%s')
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS post
	FULL JOIN TestLog.SnapShot.%s AS rm
	ON post.__pkhash__=rm.__pkhash__
	FULL JOIN TestLog.SnapShot.%s AS pre
	ON post.__pkhash__=pre.__pkhash__
	WHERE pre.__pkhash__ IS NULL
	AND rm.__pkhash__ IS NULL', @cols, @postEtlSnapName, @RecordMatchName, @preEtlSnapName)
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS post
	WHERE 1=1
	--AND post.__pkhash__ NOT IN (
	--	SELECT __pkhash__
	--	FROM TestLog.SnapShot.%s AS rm
	--)
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS pre
	)', @cols, @postEtlSnapName, @RecordMatchName, @preEtlSnapName)
	EXEC @PostEtlKeyMisMatchNameRowCount= TestLog.dbo.uspCreateQuerySnapShot @sql, @pPkField = @pkField, @pDestTableName = @PostEtlKeyMisMatchName
	IF @PostEtlKeyMisMatchNameRowCount > 0
	BEGIN
		DECLARE @PostEtlKeyMisMatchTableProfileTypeID int;
		DECLARE @PostEtlKeyMisMatchColumnProfileTypeID int;
		DECLARE @PostEtlKeyMisMatchColumnHistogramTypeID int;
		SELECT @PostEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM TestLog.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PostEtlKeyMisMatchTableProfile'
		SELECT @PostEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM TestLog.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PostEtlKeyMisMatchColumnProfile'
		SELECT @PostEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PostEtlKeyMisMatchColumnHistogram'
		EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PostEtlKeyMisMatchName, @pTableProfileTypeID = @PostEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PostEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PostEtlKeyMisMatchColumnHistogramTypeID;
	END
	ELSE 
		RAISERROR('      PostEtlKeyMisMatchName profile skipped',0,1) WITH NOWAIT;
--#endregion Table SnapShot and Profile: Post-Etl Key MisMatch (new records)

--#region Different Ways to do the same thing
	/*
	--DECLARE @PreEtlKeyMisMatchPrefix NVARCHAR(100);
	--SELECT @PreEtlKeyMisMatchPrefix = DataDescPrefix
	--FROM TestLog.dbo.DataDesc
	--WHERE DataDescID = 6;
	--DECLARE @PreEtlKeyMisMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName(@PreEtlKeyMisMatchPrefix, @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	--SET @sql = FORMATMESSAGE('
	--AND __pkhash__ IN (SELECT 
	--	pre.__pkhash__ 
	--FROM TestLog.SnapShot.%s AS pre
	--LEFT JOIN TestLog.SnapShot.%s AS post
	--ON pre.__pkhash__=post.__pkhash__
	--WHERE post.__pkhash__ IS NULL)', @preEtlSnapName, @postEtlSnapName)
	--EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @preEtlSnapName, @pDataDesc = @PreEtlKeyMisMatchPrefix, @pSubQueryFilter = @sql;
	
	--DECLARE @PostEtlKeyMisMatchPrefix NVARCHAR(100);
	--SELECT @PostEtlKeyMisMatchPrefix = DataDescPrefix
	--FROM TestLog.dbo.DataDesc
	--WHERE DataDescID = 6;
	--DECLARE @PostEtlKeyMisMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName(@PostEtlKeyMisMatchPrefix, @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	--SET @sql = FORMATMESSAGE('
	--AND __pkhash__ IN (SELECT 
	--	post.__pkhash__ 
	--FROM TestLog.SnapShot.%s AS post
	--LEFT JOIN TestLog.SnapShot.%s AS pre
	--ON post.__pkhash__=pre.__pkhash__
	--WHERE pre.__pkhash__ IS NULL)', @preEtlSnapName, @postEtlSnapName)
	--EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @preEtlSnapName, @pDataDesc = @PostEtlKeyMisMatchPrefix, @pSubQueryFilter = @sql;
	
	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,',pre.%s')
	DECLARE @PreEtlMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PreEtlKeyMatch', @pDataRequestID, @tableName, @pPkgExecKey, NULL);
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS pre
	INNER JOIN TestLog.SnapShot.%s AS post
	ON pre.__pkhash__=post.__pkhash__
	LEFT JOIN TestLog.SnapShot.%s AS premis
	ON pre.__pkhash__=premis.__pkhash__
	LEFT JOIN TestLog.SnapShot.%s AS postmis
	ON pre.__pkhash__=postmis.__pkhash__
	LEFT JOIN TestLog.SnapShot.%s AS rm
	ON pre.__pkhash__=rm.__pkhash__
	WHERE 1=1
	AND premis.__pkhash__ IS NULL
	AND postmis.__pkhash__ IS NULL
	AND rm.__pkhash__ IS NULL
	', @cols, @preEtlSnapName, @postEtlSnapName, @PreEtlKeyMisMatchName, @PostEtlKeyMisMatchName, @RecordMatchName)
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS pre
	INNER JOIN TestLog.SnapShot.%s AS post
	ON pre.__pkhash__=post.__pkhash__
	WHERE 1=1
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)
	', @cols, @preEtlSnapName, @postEtlSnapName, @RecordMatchName, @RecordMatchName)
	--EXEC @rowcount= TestLog.dbo.uspCreateQuerySnapShot @sql, @pPkField = @pkField, @pDestTableName = @PreEtlMatchName
	--EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PreEtlMatchName, @pDataDesc = @PreEtlMatchPrefix;


	SELECT @cols = TestLog.dbo.ufnGetColumnNames(@pObjectID,',post.%s')
	DECLARE @PostEtlMatchName NVARCHAR(100) = TestLog.dbo.ufnGetSnapShotName('PostEtlKeyMatch', @pDataRequestID,@tableName, @pPkgExecKey, NULL);
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS post
	INNER JOIN TestLog.SnapShot.%s AS prematch
	ON post.__pkhash__=prematch.__pkhash__', @cols, @postEtlSnapName, @PreEtlMatchName)
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	FROM TestLog.SnapShot.%s AS post
	INNER JOIN TestLog.SnapShot.%s AS pre
	ON pre.__pkhash__=post.__pkhash__
	WHERE 1=1
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)
	', @cols, @postEtlSnapName, @preEtlSnapName, @RecordMatchName, @RecordMatchName)
	--EXEC @rowcount= TestLog.dbo.uspCreateQuerySnapShot @sql, @pPkField = @pkField, @pDestTableName = @PostEtlMatchName
	--EXEC TestLog.dbo.uspCreateProfile @pTestConfigID = @pTestConfigID, @pTargetTableName = @PostEtlMatchName, @pDataDesc = @PostEtlMatchPrefix;
	*/

--#endregion Different Ways to do the same thing

--#region SnapShot: Key Match
	DECLARE @pDestDatabaseName nvarchar(100) = 'TestLog',
	@pDestSchemaName nvarchar(100) = 'SnapShot',
	@MergedKeyMatchName nvarchar(200) = TestLog.dbo.ufnGetSnapShotName('KeyMatch', @pDataRequestID,@tableName, @pPkgExecKey, NULL)
	,@destFullName nvarchar(500),
	@KeyMatchRowCount int
	SELECT @destFullName = @pDestDatabaseName+'.'+@pDestSchemaName+'.'+@MergedKeyMatchName;
	IF OBJECT_ID(@destFullName,'U') IS NOT NULL
	BEGIN
		SET @sql = FORMATMESSAGE('DROP TABLE %s;', @destFullName)
		RAISERROR(@sql,0,1) WITH NOWAIT;
		EXEC(@sql)
	END
	DECLARE @mergedColNames nvarchar(max);
	SET @mergedColNames = dbo.ufnGetColumnNames(@pObjectID,', pre.%s AS pre_%s, post.%s AS post_%s')
	SET @mergedColNames = FORMATMESSAGE('ID = IDENTITY(int, 1,1), %s',@mergedColNames)
	SET @sql = FORMATMESSAGE('
	SELECT 
		%s 
	INTO %s
	FROM TestLog.SnapShot.%s AS post
	INNER JOIN TestLog.SnapShot.%s AS pre
	ON pre.__pkhash__=post.__pkhash__
	WHERE 1=1
	AND pre.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)
	AND post.__pkhash__ NOT IN (
		SELECT __pkhash__
		FROM TestLog.SnapShot.%s AS rm
	)', @mergedColNames, @destFullName, @postEtlSnapName, @preEtlSnapName, @RecordMatchName, @RecordMatchName)
	PRINT @sql
	EXEC(@sql);
	SET @KeyMatchRowCount = @@ROWCOUNT
	RAISERROR('keyMatchCount: %i',0,1,@rowcount) WITH NOWAIT;
	SET @sql = FORMATMESSAGE('CREATE CLUSTERED INDEX PK_%s ON %s (ID);',@MergedKeyMatchName,@destFullName);
	RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);
--#endregion SnapShot: Key Match

--#region TableProfile: KeyMatchProfile
	DECLARE @KeyMatchValueMatchColumnHistogramTypeID int;
	DECLARE @KeyMatchTableProfileID int;
	SELECT @KeyMatchValueMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'KeyMatchValueMatchColumnHistogram'
	SELECT @sql = FORMATMESSAGE('INSERT INTO TestLog.dbo.TableProfile (TestConfigID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES (%i, %i, GETDATE(), %i)',@pTestConfigID, @KeyMatchRowCount, @KeyMatchValueMatchColumnHistogramTypeID);
	EXEC(@sql);
	SET @KeyMatchTableProfileID = @@IDENTITY 
--#endregion TableProfile: KeyMatchProfile

--#region Column Profiles: Key Match Value Match/MisMatch
IF @rowcount > 0 or 1=1
	BEGIN
		DECLARE columnCursor CURSOR
		FOR
		SELECT 
			attr.AttributePhysicalName AS ColumnName
			,attr.Sequence AS ColumnID
		FROM DQMF.dbo.MD_ObjectAttribute AS attr
		WHERE ObjectID = @pObjectID
		AND ISActive = 1

		OPEN columnCursor;

		DECLARE @column_name nvarchar(100)
			,@columnId int

		FETCH NEXT FROM columnCursor INTO @column_name, @columnID;

		DECLARE @KeyMatchValueMatchColumnProfileID int;
		DECLARE @KeyMatchValueMatchColumnProfileTypeID int;
		SELECT @KeyMatchValueMatchColumnProfileTypeID = ColumnProfileTypeID FROM TestLog.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'KeyMatchValueMatchColumnProfile'
		DECLARE @KeyMatchValueMisMatchColumnProfileID int;
		DECLARE @KeyMatchValueMisMatchColumnProfileTypeID int;
		SELECT @KeyMatchValueMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM TestLog.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'KeyMatchValueMisMatchColumnProfile'
		
		SELECT @KeyMatchValueMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'KeyMatchValueMatchColumnHistogram'
		DECLARE @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID int;
		SELECT @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMatchValueMisMatchColumnHistogram'
		DECLARE @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID int;
		SELECT @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM TestLog.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PostEtlKeyMatchValueMisMatchColumnHistogram'
		
		IF OBJECT_ID('tempdb..#TestLogTemp') IS NOT NULL
			DROP TABLE #TestLogTemp;
		CREATE TABLE #TestLogTemp (
			x int
		);
		SET @sql = FORMATMESSAGE('
		INSERT INTO TestLog.dbo.ColumnProfile (TableProfileID, ColumnID, ColumnCount, ColumnProfileTypeID)
		OUTPUT inserted.ColumnCount INTO #TestLogTemp
		SELECT %i AS TableProfileID, %i AS ColumnID, COUNT(*) AS ColumnCount, %i AS ColumnProfileTypeID
		FROM TestLog.SnapShot.%s AS merged
		WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
		', @KeyMatchTableProfileID, @columnID, @KeyMatchValueMatchColumnProfileTypeID, @MergedKeyMatchName, @column_name, @column_name)
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);

		SET @KeyMatchValueMatchColumnProfileID = @@IDENTITY

		INSERT INTO TestLog.dbo.ColumnProfile (TableProfileID, ColumnID, ColumnCount, ColumnProfileTypeID) 
		SELECT TOP 1 @KeyMatchTableProfileID AS TableProfileID, @columnID AS ColumnID, @KeyMatchRowCount - x AS ColumnCount, @KeyMatchValueMisMatchColumnProfileTypeID AS ColumnProfileTypeID
		FROM #TestLogTemp;
		SET @KeyMatchValueMisMatchColumnProfileID = @@IDENTITY


		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @maxDistinctCount int = 500;
			SET @sql = FORMATMESSAGE('
			INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID)
			SELECT TOP %i %i AS ColumnProfileID, merged.pre_%s AS ColumnValue, COUNT(*) AS ValueCount, %i AS ColumnHistogramTypeID
			FROM TestLog.SnapShot.%s AS merged
			WHERE ISNULL(merged.pre_%s,-1)=ISNULL(merged.post_%s,-1)
			GROUP BY merged.pre_%s
			ORDER BY COUNT(*) DESC', @maxDistinctCount, @KeyMatchValueMatchColumnProfileID, @column_name, @KeyMatchValueMatchColumnHistogramTypeID, @MergedKeyMatchName, @column_name, @column_name, @column_name)
			RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);
			
			SET @sql = FORMATMESSAGE('
			WITH valMis AS (
			SELECT merged.pre_%s, merged.post_%s
			FROM TestLog.SnapShot.%s AS merged
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
			INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID)
			SELECT *
			FROM both
			', @column_name, @column_name, @MergedKeyMatchName, @column_name, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PreEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name, 
			@maxDistinctCount, @KeyMatchValueMisMatchColumnProfileID, @column_name, @PostEtlKeyMatchValueMisMatchColumnHistogramTypeID, @column_name)
			RAISERROR(@sql, 0, 1) WITH NOWAIT;
			EXEC(@sql);

			FETCH NEXT FROM columnCursor INTO @column_name, @columnID;
		END
		CLOSE columnCursor;
		DEALLOCATE columnCursor;
	END
--#endregion Column Profiles: Key Match Value Match/MisMatch

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('  !uspRegressionTest: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
EXEC dbo.uspRegressionTest @pPkgExecKey = 312853, @pTestConfigID = 1, @pDataRequestID = 123, @pObjectID = 53913
