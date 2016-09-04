USE AutoTest
GO

SELECT 
	DISTINCT
	TOP 10
	tlog.TestConfigID
	,tlog.PreEtlSourceObjectFullName
	,tpro.RecordCount

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
LEFT JOIN DQMF.dbo.MD_ObjectAttribute AS attr
ON cpro.ColumnName = attr.AttributePhysicalName
AND tlog.ObjectID = attr.ObjectID
LEFT JOIN DQMF.dbo.MD_Object AS obj
ON obj.ObjectID = tlog.ObjectID
LEFT JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId
GROUP BY tlog.TestConfigID
	,tlog.PreEtlSourceObjectFullName
	,tpro.RecordCount