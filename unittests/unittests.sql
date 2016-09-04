USE AutoTest
GO

--#region get last PkgExecKey
SELECT TOP 20 
	pkglog.PkgExecKey
	,pkg.PkgName
	,db.DatabaseName
	,obj.ObjectSchemaName
	,obj.ObjectPhysicalName
	,tlog.TestConfigID
	,*
FROM DQMF.dbo.ETL_PackageObject AS pkgobj
JOIN DQMF.dbo.ETL_Package AS pkg
ON pkgobj.PackageID = pkg.PkgID
JOIN DQMF.dbo.AuditPkgExecution AS pkglog
ON pkg.PkgID = pkglog.PkgKey
JOIN DQMF.dbo.MD_Object obj
ON obj.ObjectID = pkgobj.OBjectID
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseID = db.DAtabaseID
LEFT JOIN AutoTest.dbo.TestConfig AS tlog
ON obj.ObjectID = tlog.ObjectID
AND pkglog.PkgExecKey = tlog.PkgExecKey
ORDER BY pkglog.PkgExecKey DESC

--#endregion get last PkgExecKey

--#region SetAuditPkgExecution start
IF 1=2
BEGIN
DECLARE @pPkgExecKeyout varchar(max);
EXEC DQMF.dbo.[SetAuditPkgExecution]
            @pPkgExecKey = null
           ,@pParentPkgExecKey = null
           ,@pPkgName = 'AutoTestTesting'
           ,@pPkgVersionMajor = 1
           ,@pPkgVersionMinor  = 1
           ,@pIsProcessStart  = 1
           ,@pIsPackageSuccessful  = 1
           ,@pPkgExecKeyout  = @pPkgExecKeyout   output
END
GO
--#endregion SetAuditPkgExecution start

--#region SetAuditPkgExecution end
IF 1=2
BEGIN
DECLARE @pPkgExecKeyout varchar(max);
EXEC DQMF.dbo.[SetAuditPkgExecution]
            @pPkgExecKey = 313271
           ,@pParentPkgExecKey = null
           ,@pPkgName = 'AutoTestTesting'
           ,@pPkgVersionMajor = 1
           ,@pPkgVersionMinor  = 1
           ,@pIsProcessStart  = 0
           ,@pIsPackageSuccessful  = 1
           ,@pPkgExecKeyout  = NULL
SELECT 313271 AS PkgExecKey
END
GO
--#endregion SetAuditPkgExecution end

--#region uspInitPkgRegressionTest
IF 1=2
BEGIN
EXEC dbo.uspInitPkgRegressionTest @pPkgExecKey = 313235
DEClaRE @pPkgExecKeyout  bigint
END
GO
--#endregion uspInitPkgRegressionTest



EXEC xp_ReadErrorLog 0, 1, N'AutoTest', N'usp', '20160701', NULL, 'DESC'


--#region uspPkgRegressionTest
IF 1=2
BEGIN
EXEC AutoTest.dbo.uspPkgRegressionTest @pPkgExecKey = 313276
END
GO
--#endregion uspPkgRegressionTest


--#region uspDataCompare
IF 1=2
BEGIN
EXEC AutoTest.dbo.uspDataCompare @pTestConfigID = 21;
END
GO
--#endregion uspDataCompare

--#region uspCreateQuerySnapShot
IF 1=2
BEGIN
DECLARE 
	@pPreEtlDatabaseName varchar(100) = 'Lien'
	,@pPreEtlSchemaName varchar(100) = 'Adtc'
	,@pPreEtlTableName varchar(100) = 'SM_02_DischargeFact'
	,@pPostEtlDatabaseName varchar(100) = 'Lien'
	,@pPostEtlSchemaName varchar(100) = 'Adtc'
	,@pPostEtlTableName varchar(100) = 'SM_03_DischargeFact'
	,@pObjectPkColumns varchar(100) = 'PatientID, AccountNum'
DECLARE @pQuery varchar(max),
	@pKeyColumns varchar(max) = @pObjectPkColumns,
	@pHashKeyColumns varchar(max) = @pObjectPkColumns,
	@pDestDatabaseName varchar(100) = 'AutoTest',
	@pDestSchemaName varchar(100) = 'SnapShot',
	@pDestTableName varchar(100) = 'waldo'

SET @pQuery = FORMATMESSAGE('SELECT * FROM %s.%s.%s', @pPreEtlDatabaseName, @pPreEtlSchemaName, @pPreEtlTableName)
EXEC AutoTest.dbo.uspCreateQuerySnapShot @pQuery=@pQuery, @pKeyColumns=@pKeyColumns, @pHashKeyColumns=@pHashKeyColumns, @pDestDatabaseName=@pDestDatabaseName,@pDestSchemaName=@pDestSchemaName,@pDestTableName=@pDestTableName
END
GO
--#endregion uspCreateQuerySnapShot



--#region uspGetColumnNames
IF 1=2
BEGIN
DECLARE 
	@pDatabaseName varchar(100) = 'Lien'
	,@pSchemaName varchar(100) = 'Adtc'
	,@pObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pIntersectingDatabaseName varchar(100) = 'Lien'
	,@pIntersectingObjectName varchar(100) = 'SM_02_DischargeFact'
	,@pIntersectingSchemaName varchar(100) = 'Adtc'
	,@pFmt varchar(max) = 'pre.%s,'
	,@pColStr varchar(max)
SET @pFmt = ',pre_%s=pre.%s,post_%s=post.%s'
EXEC dbo.uspGetColumnNames 
	@pDatabaseName
	,@pSchemaName
	,@pObjectName
	,@pFmt = @pFmt
	,@pColStr = @pColStr OUTPUT

PRINT @pColStr
END
GO
--#endregion uspGetColumnNames

--#region Stand Alone Profile
IF 1=2
BEGIN
DECLARE @TestTypeID int;
DECLARE @TableProfileTypeID int;
DECLARE @ColumnProfileTypeID int;
DECLARE @ColumnHistogramTypeID int;
SELECT @TestTypeID = TestTypeID FROM AutoTest.dbo.TestType WHERE TestTypeDesc = 'StandAloneTableProfile'
SELECT @TableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'StandAloneTableProfile'
SELECT @ColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'StandAloneColumnProfile'
SELECT @ColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'StandAloneColumnHistogram'



DECLARE @pTestConfigID int = 25;
SELECT @pTestConfigID=MAX(TestConfigID) FROM AutoTest.dbo.TestConfig
SET @pTestConfigID = 25;
DECLARE @PreEtlKeyMisMatchSnapShotName varchar(100)
SELECT @PreEtlKeyMisMatchSnapShotName = RecordMatchSnapShotName
FROM AutoTest.dbo.TestConfig WHERE TestConfigID = @pTestConfigID
END
GO
--#endregion Stand Alone Profile

--#region uspAdHocTableViewProfile
IF 1=2
BEGIN
	EXEC AutoTest.dbo.uspAdHocTableViewProfile 'CommunityMart', 'dbo', 'ReferralFact'
END
--#endregion uspAdHocTableViewProfile

--#region uspAdHocDataProfile
IF 1=2
BEGIN
	EXEC AutoTest.dbo.uspAdHocDataProfile 'CommunityMart'
END
--#endregion uspAdHocDataProfile





--#region uspGetKey
IF 1=2
BEGIN
DECLARE @KeyColumns varchar(max) = '';
EXEC AutoTest.dbo.uspGetKey 
	@pDatabaseName = 'AutoTest',
	@pSchemaName = 'SnapShot',
	@pObjectName = 'PreEtl_TestConfigID1',
	@pFmt = '%s,',
	@pColStr = @KeyColumns OUTPUT
PRINT @KeyColumns;
END
GO
--#endregion uspGetKey

--#region clean 
IF 1=2
BEGIN
	EXEC AutoTest.dbo.uspDropSnapShot @pMaxSchemaSizeMB=0
	DELETE AutoTest.dbo.ColumnHistogram
	DELETE AutoTest.dbo.ColumnProfile
	DELETE AutoTest.dbo.TableProfile
	DELETE AutoTest.dbo.TestConfig
	DELETE AutoTest.dbo.LogDataDiff
END
GO
--#endregion clean

--#region LogDataDiff
IF 1=1
BEGIN
	SELECT * FROM AutoTest.dbo.LogDataDiff
END
--#endregion LogDataDiff


--#region row counts
IF 1=2
BEGIN
EXEC sp_MSforeachtable @command1 = '
DECLARE @rcount int;
DECLARE @tableName varchar(500);

SET @tableNAme = ''%sHoNoSFact''

IF OBJECT_SCHEMA_NAME(OBJECT_ID(''?'')) = ''SnapShot'' AND ''?'' LIKE ISNULL(@tableName, ''?'')
BEGIN
	SELECT @rcount=COUNT(*) FROM ?;
	INSERT INTO ##tab VALUES (''?'', @rcount);
END
', @precommand = 'CREATE TABLE ##tab (
	TableName varchar(200)
	,rcount int
);',@postcommand = 'SELECT * FROM ##tab order by rcount desc; DROP TABLE ##tab;'
END
--#endregoin row counts


--#region fact demotions
IF 1=2
BEGIN
DECLARE @DatabaseName varchar(500) = 'CommunityMart'

DECLARE @Demotions TABLE (
	ParentTableName varchar(100)
	,NewIDColumnName varchar(100)
);

INSERT INTO @Demotions VALUES ('dbo.ReferralFact','LocalReportingOfficeID')

;WITH mr_Profile AS (
	SELECT MAX(TestConfigID) AS TestConfigID, tlog.PreEtlSourceObjectFullName
	FROM AutoTest.dbo.TestConfig AS tlog
	GROUP BY tlog.PreEtlSourceObjectFullName
), ck AS (
	SELECT tlog.PreEtlSourceObjectFullName, cpro.ColumnName AS CandidateKey, tab.object_id, tpro.RecordCount, cpro.ColumnCount, tlog.TestConfigID
	FROM AutoTest.dbo.TestConfig AS tlog
	JOIN mr_Profile
	ON mr_Profile.TestConfigID = tlog.TestConfigID
	JOIN CommunityMart.sys.schemas AS sch
	ON sch.name = PARSENAME(tlog.PreEtlSourceObjectFullName,2)
	JOIN CommunityMart.sys.tables AS tab
	ON tab.name = PARSENAME(tlog.PreEtlSourceObjectFullName,1)
	AND tab.schema_id = sch.schema_id
	JOIN AutoTest.dbo.TableProfile AS tpro
	ON tlog.TestConfigID = tpro.TestConfigID
	JOIN AutoTest.dbo.ColumnProfile AS cpro
	ON tpro.TableProfileID = cpro.TableProfileID
	JOIN CommunityMart.sys.columns AS col
	ON tab.object_id = col.object_id
	AND cpro.TableProfileID = tpro.TableProfileID
	AND cpro.ColumnName = col.name
	WHERE tpro.RecordCount = cpro.ColumnCount
	AND tpro.RecordCount > 1
	AND cpro.ColumnName NOT IN ('__idkey__', 'ETLAuditID')
	AND cpro.ColumnName LIKE '%ID'
),parent_child_pairs  AS (
	SELECT child_schema.name+'.'+ child.name AS ChildTable, PARSENAME(ParentCk.PreEtlSourceObjectFullName,2)+'.'+ PARSENAME(ParentCk.PreEtlSourceObjectFullName,1) AS ParentTable, fk.name AS JoinColumn, ParentCk.RecordCount AS ParentRecordCount, ParentCk.ColumnCount AS ParentColumnCount, ChildCk.RecordCount AS ChildRecordCount, child_cpro.ColumnCount AS ChildColumnCount
	FROM ck AS ParentCk
	JOIN CommunityMart.sys.columns AS fk
	ON ParentCk.CandidateKey = fk.name
	JOIN CommunityMart.sys.tables AS child
	ON fk.object_id = child.object_id

	JOIN CommunityMart.sys.schemas AS child_schema
	ON child.schema_id = child_schema.schema_id
	JOIN ck AS ChildCk
	ON PARSENAME(ChildCk.PreEtlSourceObjectFullName,2)+'.'+ PARSENAME(ChildCk.PreEtlSourceObjectFullName,1) = child_schema.name+'.'+ child.name
	JOIN AutoTest.dbo.TestConfig AS child_tlog
	ON child_tlog.TestConfigID = ChildCk.TestConfigID
	JOIN AutoTest.dbo.TableProfile AS child_tpro
	ON child_tpro.TestConfigID = child_tlog.TestConfigID
	JOIN AutoTest.dbo.ColumnProfile AS child_cpro
	ON child_tpro.TableProfileID = child_cpro.TableProfileID
	AND child_cpro.ColumnName = fk.name
	WHERE child_cpro.ColumnCount <= ParentCk.RecordCount
	AND ChildCk.PreEtlSourceObjectFullName != ParentCk.PreEtlSourceObjectFullName
	--JOIN ck AS child
	--ON parent.CandidateKey = child.CandidateKey
	--AND parent.RecordCount <= child.RecordCount
	--AND parent.PreEtlSourceObjectFullName != child.PreEtlSourceObjectFullName
	--JOIN CommunityMart.sys.columns AS col
	--ON ck.ColumnName = col.name
	--AND ck.object_id != col.object_id
	--JOIN CommunityMart.sys.tables AS tab
	--ON col.object_id = tab.object_id
	--JOIN CommunityMart.sys.schemas AS sch
	--ON tab.schema_id = sch.schema_id
	--GROUP BY ck.PreEtlSourceObjectFullName, ck.ColumnName, sch.name, tab.name, col.name
), roots AS (
	SELECT parent_child_pairs.ParentTable AS RootTableName
	FROM parent_child_pairs
	WHERE PARSENAME(parent_child_pairs.ParentTable,2) != 'Dim'
	EXCEPT 
	SELECT parent_child_pairs.ChildTable AS RootTableName
	FROM parent_child_pairs
	WHERE PARSENAME(parent_child_pairs.ParentTable,2) != 'Dim'
), tree AS (
	SELECT RootTableName AS ChildTable, NULL AS ParentTable, NULL AS JoinColumn
	FROM roots
	UNION
	SELECT ChildTable, ParentTable, parent_child_pairs.JoinColumn
	FROM parent_child_pairs
), recursive_build AS (
	SELECT tree.ChildTable, tree.ParentTable, tree.JoinColumn, CAST('' AS varchar(max)) AS DemotedTables
	FROM tree
	WHERE tree.ParentTable IS NULL
	UNION ALL
	SELECT tree.ChildTable, tree.ParentTable, tree.JoinColumn, CAST(DemotedTables + ','+recursive_build.ChildTable AS varchar(max)) AS DemotedTables
	FROM tree
	JOIN recursive_build
	ON tree.ParentTable = recursive_build.ChildTable
)
SELECT *
--FROM parent_child_pairs
--WHERE parent_child_pairs.ChildTable IN ('dbo.DischargeFact', 'dbo.ReferralFact')
--ORDER BY parent_child_pairs.ParentTable, parent_child_pairs.ChildTable
--OPTION (MAXRECURSION 0);
FROM parent_child_pairs
--WHERE (parent_child_pairs.ChildTable LIKE '%ReferralFact%'
--OR parent_child_pairs.ChildTable LIKE '%DischargeFact%')
--AND (parent_child_pairs.ChildTable LIKE '%Fact%'
--AND parent_child_pairs.ParentTable LIKE '%Fact%')
ORDER BY parent_child_pairs.ChildTable
END


IF 1=2
BEGIN
USE CommunityMart
DECLARE @Demotions TABLE (
	TableName varchar(100)
	,LookupColumnName varchar(100)
	,NewColumnName varchar(100)
);

INSERT INTO @Demotions VALUES ('dbo.PersonFact', '', '');

SELECT tlog.PreEtlSourceObjectFullName, cpro.ColumnName
FROM AutoTest.dbo.TestConfig AS tlog
JOIN AutoTest.dbo.TestType AS tt
ON tlog.TestTypeID = tt.TestTypeID
JOIN AutoTest.dbo.TableProfile AS tpro
ON tlog.TestConfigID = tpro.TestConfigID
JOIN AutoTest.dbo.ColumnProfile AS cpro
ON cpro.TableProfileID = tpro.TableProfileID
WHERE tpro.RecordCount = cpro.ColumnCount
AND cpro.ColumnName LIKE '%ID'
AND tpro.RecordCount != 0

SELECT COUNT(DISTINCT LHAID) LHAID, COUNT(DISTINCT PostalCodeID) PostalCodeID
FROM CommunityMart.Dim.PostalCode

DECLARE fact_cur CURSOR
FOR 
SELECT DISTINCT DB_NAME(), sch.name, tab.name 
FROM CommunityMart.sys.tables AS tab
JOIN CommunityMart.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
WHERE tab.name LIKE '%Fact'
AND DB_NAME()+'.'+ sch.name+'.'+tab.name NOT IN (
	SELECT PreEtlSourceObjectFullName
	FROM AutoTest.dbo.TestConfig 
)

DECLARE @DatabaseName varchar(500);
DECLARE @SchemaName varchar(500);
DECLARE @TableName varchar(500);

OPEN fact_cur;

FETCH NEXT FROM fact_cur INTO @DatabaseName, @SchemaName, @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT FORMATMESSAGE('%s.%s.%s','CommunityMart', 'dbo', @TableName);
	EXEC AutoTest.dbo.uspAdHocTableViewProfile 'CommunityMart', 'dbo', @TableName;
	FETCH NEXT FROM fact_cur INTO @DatabaseName, @SchemaName, @TableName;
END

CLOSE fact_cur;
DEALLOCATE fact_cur;
END
--#region fact demotions
