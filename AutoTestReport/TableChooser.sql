DECLARE @PkgExecKey int = null;
DECLARE @DatabaseID int = null;

SELECT *
	,CAST((1.*PostEtl_RecordCount/sub.PreEtl_RecordCount-1) AS decimal(10,8)) AS PercentChange
FROM (
SELECT 
	piv.TestDate
	,piv.PkgName 
	,piv.RegressionTestAge 
	,piv.PreEtlSourceObjectFullName
	,piv.DatabaseName
	,piv.ObjectSchemaName 
	,piv.ObjectPhysicalName 
	,piv.ObjectID	
	,piv.PkgExecKey 
	,piv.TestConfigID 
	,piv.RecordMatchTableProfile 
	,piv.KeyMatchTableProfile 
	,piv.PreEtlKeyMisMatchTableProfile 
	,piv.PostEtlKeyMisMatchTableProfile	
	,CASE WHEN ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PreEtlKeyMisMatchTableProfile,0) = 0 THEN NULL ELSE ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PreEtlKeyMisMatchTableProfile,0) END AS PreEtl_RecordCount
	,CASE WHEN ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PostEtlKeyMisMatchTableProfile,0) = 0 THEN NULL ELSE ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PostEtlKeyMisMatchTableProfile,0) END AS PostEtl_RecordCount
	,ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) AS KeyMatch_Count
FROM (
SELECT tlog.PkgExecKey, pkg.PkgName ,tlog.TestConfigID, tlog.PreEtlSourceObjectFullName, db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName, tlog.ObjectID, tpro.RecordCount, tlog.TestDate, 
dbo.ufnPrettyDateDiff(tlog.TestDate, GETDATE()) + ' ago' 
 AS RegressionTestAge
, tprot.TableProfileTypeDesc
,db.DatabaseId
FROM AutoTest.dbo.TestConfig AS tlog
JOIN AutoTest.dbo.TestType AS tt
ON tlog.TestTypeID = tt.TestTypeID
LEFT JOIN AutoTest.dbo.TableProfile AS tpro
ON tlog.TestConfigID = tpro.TestConfigID
LEFT JOIN AutoTest.dbo.TableProfileType AS tprot
ON tprot.TableProfileTypeID = tpro.TableProfileTypeID
LEFT JOIN DQMF.dbo.MD_Object AS obj
ON obj.ObjectID = tlog.ObjectID
LEFT JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId
LEFT JOIN DQMF.dbo.AuditPkgExecution AS pkgaud
ON tlog.PkgExecKey = pkgaud.PkgExecKey
LEFT JOIN DQMF.dbo.ETL_Package AS pkg
ON pkg.PkgId = pkgaud.PkgKey
WHERE 1=1	
--AND tlog.ComparisonRuntimeSeconds IS NOT NULL
) sub
PIVOT	
(
	SUM(RecordCount) FOR TableProfileTypeDesc IN ([RecordMatchTableProfile], [KeyMatchTableProfile], [PreEtlKeyMisMatchTableProfile], [PostEtlKeyMisMatchTableProfile])
) AS piv
WHERE 1=1
AND piv.PkgExecKey= ISNULL(@PkgExecKey, piv.PkgExecKey)
AND piv.DatabaseID= ISNULL(@DatabaseID, piv.DatabaseID)
) sub
ORDER BY sub.PkgExecKey DESC, sub.TestConfigID DESC