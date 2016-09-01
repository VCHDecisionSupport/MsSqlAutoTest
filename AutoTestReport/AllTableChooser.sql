SELECT 
	pkg.PkgName
	,PARSENAME(PreEtlSourceObjectFullName,3) AS [Database]
	,PARSENAME(PreEtlSourceObjectFullName,2) AS [Schema]
	,PARSENAME(PreEtlSourceObjectFullName,1) AS [Table]
	--,PostEtlSourceObjectFullName
	,sub.TestConfigID
	,dbo.ufnPrettyDateDiff(TableProfileDate, GETDATE())+ ' ago' AS PrettyLastTestDate
	,TestDate
	,tt.TestTypeDesc
	,tpro.RecordCount
	--,tpro.TableProfileDate
	,tprot.TableProfileTypeDesc
FROM (

SELECT 
	tlog.PreEtlSourceObjectFullName
	,tlog.PostEtlSourceObjectFullName
	,tlog.TestConfigID
	,tlog.TestTypeID
	,tlog.TestDate
	,tlog.PkgExecKey
	,ROW_NUMBER() OVER(PARTITION BY tlog.PreEtlSourceObjectFullName, tlog.PostEtlSourceObjectFullName ORDER BY tlog.TestDate DESC) AS TestDate_rn
	,ROW_NUMBER() OVER(PARTITION BY tlog.PreEtlSourceObjectFullName, tlog.PostEtlSourceObjectFullName ORDER BY tpro.TableProfileDate DESC) AS TableProfileDate_rn
	,tpro.TableProfileID
FROM AutoTest.dbo.TestConfig AS tlog
JOIN AutoTest.dbo.TestType AS tt
ON tlog.TestTypeID = tt.TestTypeID
LEFT JOIN DQMF.dbo.AuditPkgExecution AS pkg
ON pkg.PkgExecKey = tlog.PkgExecKey
JOIN AutoTEst.dbo.TableProfile AS tpro
ON tlog.TestConfigID = tpro.TestConfigID
) sub
JOIN AutoTest.dbo.TestType AS tt
ON sub.TestTypeID = tt.TestTypeID
LEFT JOIN DQMF.dbo.AuditPkgExecution AS pkg
ON pkg.PkgExecKey = sub.PkgExecKey
JOIN AutoTEst.dbo.TableProfile AS tpro
ON sub.TestConfigID = tpro.TestConfigID
JOIN AutoTest.dbo.TableProfileType AS tprot
ON tprot.TableProfileTypeID = tpro.TableProfileTypeID

WHERE 1=1
AND sub.TestDate_rn = 1
AND sub.TableProfileDate_rn = 1
ORDER BY TestDate DESC