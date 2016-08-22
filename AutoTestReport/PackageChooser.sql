
SELECT pkg.PkgName AS PackageName, map.PackageID
,CASE 
WHEN DATEDIFF(hour, MAX(tlog.TestDate), GETDATE()) = 1
	THEN FORMATMESSAGE('%i minutes', DATEDIFF(minute, MAX(tlog.TestDate), GETDATE()))
WHEN DATEDIFF(day, MAX(tlog.TestDate), GETDATE()) = 0
	THEN FORMATMESSAGE('%i hours', DATEDIFF(hour, MAX(tlog.TestDate), GETDATE()))
ELSE FORMATMESSAGE('%i days', DATEDIFF(hour, MAX(tlog.TestDate), GETDATE()))
END
 AS RegressionTestAge

,MAX(tlog.PkgExecKey) PkgExecKey, COUNT(DISTINCT tlog.ObjectID) AS TablesTested
,MAX(tlog.TestDate) AS TestDate
FROM DQMF.dbo.ETL_PackageObject AS map
JOIN DQMF.dbo.MD_Object obj
ON obj.ObjectID = map.OBjectID
JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId
JOIN DQMF.dbo.ETL_Package AS pkg
ON pkg.PkgId = map.PackageID
JOIN DQMF.dbo.AuditPkgExecution AS pkgaud
ON map.PackageID = pkgaud.PkgKey
JOIN AutoTest.dbo.TestConfig AS tlog
ON tlog.PkgExecKey = pkgaud.PkgExecKey
GROUP BY pkg.PkgName, map.PackageID, tlog.PkgExecKey
ORDER BY MAX(tlog.TestDate) DESC