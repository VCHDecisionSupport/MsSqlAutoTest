SELECT 
	pkg.PkgName
	,PARSENAME(PreEtlSourceObjectFullName,3) AS [Database]
	,PARSENAME(PreEtlSourceObjectFullName,2) AS [Schema]
	,PARSENAME(PreEtlSourceObjectFullName,1) AS [Table]
	--,PostEtlSourceObjectFullName
	,TestConfigID
	,dbo.ufnPrettyDateDiff(TestDate, GETDATE())+ ' ago' AS PrettyLastTestDate
	,TestDate
	,tt.TestTypeDesc
FROM (

SELECT 
	tlog.PreEtlSourceObjectFullName
	,tlog.PostEtlSourceObjectFullName
	,tlog.TestConfigID
	,tlog.TestTypeID
	,tlog.TestDate
	,tlog.PkgExecKey
	,ROW_NUMBER() OVER(PARTITION BY tlog.PreEtlSourceObjectFullName, tlog.PostEtlSourceObjectFullName ORDER BY tlog.TestDate DESC) AS rn
FROM AutoTest.dbo.TestConfig AS tlog
) sub
JOIN AutoTest.dbo.TestType AS tt
ON sub.TestTypeID = tt.TestTypeID
LEFT JOIN DQMF.dbo.AuditPkgExecution AS pkg
ON pkg.PkgExecKey = sub.PkgExecKey
WHERE rn = 1
ORDER BY TestDate DESC