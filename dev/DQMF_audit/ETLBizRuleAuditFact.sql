SELECT DATEPART(year, pkglog.ExecStartDT), DATEPART(month, pkglog.ExecStartDT), pkg.PkgName, brlog.TableId, brlog.DatebaseId
	,COUNT(*)
FROM DQMF.dbo.ETLBizruleAuditFact AS brlog
JOIN DQMF.dbo.AuditPkgExecution AS pkglog
ON brlog.PkgExecKey = pkglog.PkgExecKey
JOIN DQMF.dbo.ETL_Package AS pkg
ON pkglog.PkgKey = pkg.PkgID
GROUP BY DATEPART(year, pkglog.ExecStartDT), DATEPART(month, pkglog.ExecStartDT), pkg.PkgName, brlog.TableId, brlog.DatebaseId
ORDER BY DATEPART(year, pkglog.ExecStartDT), DATEPART(month, pkglog.ExecStartDT), pkg.PkgName, brlog.TableId, brlog.DatebaseId