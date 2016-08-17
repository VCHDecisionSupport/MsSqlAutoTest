DECLARE @PkgExecKey int = 313077
DECLARE @ObjectID int = 53898

SELECT MAX(PkgExecKey)
FROM AutoTest.dbo.TestConfigLog

SELECT *
FROM DQMF.dbo.MD_Object 
WHERE ObjectID = @ObjectID
-- SourceSystemClientID, SourceSchoolDtlID

SELECT COUNT(*) AS CurrentCount
FROM CommunityMart.dbo.SchoolHistoryFact AS fact
-- 2043914

SELECT tabprotype.TableProfileTypeDesc, tabpro.*, tlog.*
FROM TestConfigLog tlog
JOIN TableProfile tabpro
ON tlog.TestConfigLogID = tabpro.TestConfigLogID
JOIN TableProfileType tabprotype
ON tabpro.TableProfileTypeID = tabprotype.TableProfileTypeID
WHERE PkgExecKey = @PkgExecKey


SELECT COUNT(*) AS PostKeyMisMatch2CurrentFact
FROM (
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PostEtl_TestConfigLogID96
EXCEPT
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM CommunityMart.dbo.SchoolHistoryFact AS fact
) sub
-- 0


SELECT COUNT(*) AS PostKeyMisMatch
FROM (
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PostEtl_TestConfigLogID96
EXCEPT
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PreEtl_TestConfigLogID96
) sub
-- 40679


SELECT COUNT(*) AS RecordMatch
FROM (
SELECT *
FROM AutoTest.SnapShot.PreEtl_TestConfigLogID96
INTERSECT
SELECT *
FROM AutoTest.SnapShot.PostEtl_TestConfigLogID96
) sub
-- 1772830

