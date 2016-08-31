DECLARE @TestConfigID int = 405


SELECT 
	pvt.ColumnName
	,pvt.[RecordMatchColumnProfile] AS RecordMatch
	,pvt.[KeyMatchValueMatchColumnProfile] AS KeyMatchValueMatch
	,pvt.[KeyMatchValueMisMatchColumnProfile] AS KeyMatchValueMisMatch
	,pvt.[PostEtlKeyMisMatchColumnProfile] AS NewRecord
	,ISNULL(pvt.[PreEtlKeyMisMatchColumnProfile],0) AS DeletedRecord
FROM (
SELECT tlog.*, cpro.ColumnName, cpro.ColumnCount, cprot.ColumnProfileTypeDesc
FROM AutoTest.dbo.TestConfig AS tlog
JOIN AutoTest.dbo.TestType AS tt
ON tlog.TestTypeID = tt.TestTypeID
LEFT JOIN AutoTest.dbo.TableProfile AS tpro
ON tlog.TestConfigID = tpro.TestConfigID
LEFT JOIN AutoTest.dbo.TableProfileType AS tprot
ON tprot.TableProfileTypeID = tpro.TableProfileTypeID
LEFT JOIN AutoTest.dbo.ColumnProfile AS cpro
ON tpro.TableProfileID = cpro.TableProfileID
LEFT JOIN AutoTest.dbo.ColumnProfileType AS cprot
ON cprot.ColumnProfileTypeID = cpro.ColumnProfileTypeID
LEFT JOIN DQMF.dbo.MD_Object AS obj
ON obj.ObjectID = tlog.ObjectID
LEFT JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId
LEFT JOIN DQMF.dbo.AuditPkgExecution AS pkgaud
ON tlog.PkgExecKey = pkgaud.PkgExecKey
LEFT JOIN DQMF.dbo.ETL_Package AS pkg
ON pkg.PkgId = pkgaud.PkgKey
WHERE 1=1	
) sub
PIVOT
(
	SUM(ColumnCount) FOR ColumnProfileTypeDesc IN (
			[RecordMatchColumnProfile],
			[KeyMatchValueMatchColumnProfile],
			[KeyMatchValueMisMatchColumnProfile],
			[PreEtlKeyMisMatchColumnProfile],
			[PostEtlKeyMisMatchColumnProfile]
		)
) AS pvt
WHERE 1=1
AND pvt.TestConfigID = ISNULL(@TestConfigID, pvt.TestConfigID)