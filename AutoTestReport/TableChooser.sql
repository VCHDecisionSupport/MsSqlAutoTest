DECLARE @PkgExecKey int = 313261;


SELECT 
	piv.TestDate
	,piv.PkgName 
	,piv.RegressionAgeDays 
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
	,ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PreEtlKeyMisMatchTableProfile,0) AS PreEtl_RecordCount
	,ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) + ISNULL(PostEtlKeyMisMatchTableProfile,0) AS PostEtl_RecordCount
	,ISNULL(RecordMatchTableProfile,0) + ISNULL(KeyMatchTableProfile,0) AS KeyMatch_Count
FROM (
SELECT tlog.PkgExecKey, pkg.PkgName ,tlog.TestConfigID, tlog.PreEtlSourceObjectFullName, db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName, tlog.ObjectID, tpro.RecordCount, tlog.TestDate, 
CASE 
WHEN DATEDIFF(hour, tlog.TestDate, GETDATE()) = 1
	THEN FORMATMESSAGE('%i minutes', DATEDIFF(minute, tlog.TestDate, GETDATE()))
WHEN DATEDIFF(day, tlog.TestDate, GETDATE()) = 0
	THEN FORMATMESSAGE('%i hours', DATEDIFF(hour, tlog.TestDate, GETDATE()))
ELSE FORMATMESSAGE('%i days', DATEDIFF(hour, tlog.TestDate, GETDATE()))
END
 AS RegressionTestAge
, tprot.TableProfileTypeDesc
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
AND piv.PkgExecKey= @PkgExecKey
ORDER BY piv.PkgExecKey DESC, TestConfigID DESC