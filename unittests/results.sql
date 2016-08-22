SELECT COUNT(*) AS CurrentTableRecrodCount
FROM HCRSMart.HCRS.Admission;

SELECT COUNT(*) AS PreEtl
FROM AutoTest.SnapShot.PreETl_TestConfigID3
SELECT COUNT(*) AS PostEtl
FROM AutoTest.SnapShot.PostETl_TestConfigID3
SELECT COUNT(*) AS KeyMatch
FROM AutoTest.SnapShot.KeyMatch_TestConfigID3
SELECT COUNT(*) AS PreEtlKeyMisMatch
FROM AutoTest.SnapShot.PreEtlKeyMisMatch_TestConfigID3
SELECT COUNT(*) AS PostEtlKeyMisMatch
FROM AutoTest.SnapShot.PostEtlKeyMisMatch_TestConfigID3

SELECT PreEtlSourceObjectFullName
,tprot.TableProfileTypeDesc
,RecordCount
--,SUM(RecordCount)
FROM AutoTest.dbo.TestConfig AS tlog
JOIN AutoTest.dbo.TestType AS tt
ON tlog.TestTypeID = tt.TestTypeID
JOIN AutoTest.dbo.TableProfile AS tpro
ON tlog.TestConfigID = tpro.TestConfigID
JOIN AutoTest.dbo.TableProfileType AS tprot
ON tprot.TableProfileTypeID = tpro.TableProfileTypeID
JOIN DQMF.dbo.MD_Object AS obj
ON obj.ObjectID = tlog.ObjectID
JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId
JOIN DQMF.dbo.AuditPkgExecution AS pkgaud
ON tlog.PkgExecKey = pkgaud.PkgExecKey
JOIN DQMF.dbo.ETL_Package AS pkg
ON pkg.PkgId = pkgaud.PkgKey
WHERE 1=1	
AND tlog.PreEtlSourceObjectFullName LIKE '%HCRSMart.HCRS.Admission%'
AND (
tprot.TableProfileTypeDesc LIKE 'PreEtlKeyMisMatchTableProfile'
OR tprot.TableProfileTypeDesc LIKE 'KeyMatchTableProfile'
--OR tprot.TableProfileTypeDesc LIKE 'RecordMatchTableProfile'
)
--GROUP BY tlog.PreEtlSourceObjectFullName
--SELECT COUNT(*)
--FROM AutoTest.SnapShot.PreETl_TestConfigID1
--SELECT COUNT(*)
--FROM AutoTest.SnapShot.PreETl_TestConfigID1
--SELECT COUNT(*)
--FROM AutoTest.SnapShot.PreETl_TestConfigID1
