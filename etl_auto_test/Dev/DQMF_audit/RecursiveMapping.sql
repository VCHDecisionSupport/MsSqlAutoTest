USE DQMF
GO


--SELECT *
--INTO gcAuditPkgExecution
--FROM AuditPkgExecution


IF OBJECT_ID('ETL_ParentChildPackage','U') IS NOT NULL
DROP TABLE ETL_ParentChildPackage;

CREATE TABLE ETL_ParentChildPackage
(
	Level int,
	ParentPkgName varchar(200),
	ChildPkgName varchar(200)
);


;WITH PkgCte AS (
SELECT pkglog.PkgExecKey, pkglog.ParentPkgExecKey, -1 AS Level, pkg.*
FROM gcAuditPkgExecution AS pkglog
JOIN ETL_Package AS pkg
ON pkglog.PkgKey = pkg.PkgID
WHERE ParentPkgExecKey IS NULL
UNION ALL
SELECT pkglog.PkgExecKey, pkglog.ParentPkgExecKey, Level+1, pkg.*
FROM gcAuditPkgExecution AS pkglog
JOIN ETL_Package AS pkg
ON pkglog.PkgKey = pkg.PkgID
JOIN PkgCte 
ON PkgCte.PkgExecKey = pkglog.ParentPkgExecKey
)
INSERT INTO ETL_ParentChildPackage
SELECT DISTINCT PkgCte.Level, parentExec.PkgName, childExec.PkgName
FROM PkgCte
JOIN gcAuditPkgExecution AS parentExec
ON PkgCte.ParentPkgExecKey = parentExec.PkgExecKey
JOIN gcAuditPkgExecution AS childExec
ON PkgCte.PkgExecKey = childExec.PkgExecKey

SELECT *
FROM 


--#region LEFT JOIN not allowed


--;WITH PkgCte AS (
--SELECT thispkgexec.PkgName AS ParentPkgName, parentpkgexec.PkgName, 0 AS Level, thispkgexec.PkgExecKey, thispkgexec.*
--FROM AuditPkgExecution AS thispkgexec
--LEFT JOIN AuditPkgExecution AS parentpkgexec
--ON thispkgexec.ParentPkgExecKey = parentpkgexec.PkgExecKey
--JOIN ETL_Package AS parentpkg
--ON parentpkgexec.PkgKey = parentpkg.PkgID
--WHERE parentpkgexec.PkgExecKey IS NULL
--UNION ALL
--SELECT thispkgexec.PkgName AS ParentPkgName, parentpkgexec.PkgName, 0 AS Level, thispkgexec.PkgExecKey, thispkgexec.*
--FROM AuditPkgExecution AS thispkgexec
--LEFT JOIN AuditPkgExecution AS parentpkgexec
--ON thispkgexec.ParentPkgExecKey = parentpkgexec.PkgExecKey
--JOIN ETL_Package AS parentpkg
--ON parentpkgexec.PkgKey = parentpkg.PkgID
--JOIN PkgCte
--ON parentpkgexec.PkgKey = parentpkg.PkgID
--)
--SELECT DISTINCT PkgCte.PkgName, PkgCte.Level
--FROM PkgCte
--#endregion LEFT JOIN not allowed