DECLARE @PkgExecKey int = 313077
DECLARE @ObjectID int = 53898

SELECT MAX(PkgExecKey)
FROM AutoTest.dbo.TestConfig

SELECT *
FROM DQMF.dbo.MD_Object 
WHERE ObjectID = @ObjectID
-- SourceSystemClientID, SourceSchoolDtlID

SELECT COUNT(*) AS CurrentCount
FROM CommunityMart.dbo.SchoolHistoryFact AS fact
-- 2043914

SELECT tabprotype.TableProfileTypeDesc, tabpro.*, tlog.*
FROM TestConfig tlog
JOIN TableProfile tabpro
ON tlog.TestConfigID = tabpro.TestConfigID
JOIN TableProfileType tabprotype
ON tabpro.TableProfileTypeID = tabprotype.TableProfileTypeID
WHERE PkgExecKey = @PkgExecKey


SELECT COUNT(*) AS PostKeyMisMatch2CurrentFact
FROM (
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PostEtl_TestConfigID96
EXCEPT
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM CommunityMart.dbo.SchoolHistoryFact AS fact
) sub
-- 0


SELECT COUNT(*) AS PostKeyMisMatch
FROM (
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PostEtl_TestConfigID96
EXCEPT
SELECT SourceSystemClientID, SourceSchoolDtlID
FROM AutoTest.SnapShot.PreEtl_TestConfigID96
) sub
-- 40679


SELECT COUNT(*) AS RecordMatch
FROM (
SELECT *
FROM AutoTest.SnapShot.PreEtl_TestConfigID96
INTERSECT
SELECT *
FROM AutoTest.SnapShot.PostEtl_TestConfigID96
) sub
-- 1772830

