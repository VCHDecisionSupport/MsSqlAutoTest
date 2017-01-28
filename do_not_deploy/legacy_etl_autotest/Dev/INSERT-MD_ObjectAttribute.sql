USE CommunityMart
GO
DECLARE @DatabaseName VARCHAR(100) = 'CommunityMart'

UPDATE DQMF.dbo.MD_ObjectAttribute 
--SET IsDistinct = 1
SET IsBusinessKey = 1
FROM DQMF.dbo.MD_ObjectAttribute AS attr
WHERE attr.ObjectAttributeID IN (
	SELECT ObjectAttributeID
	FROM (
	SELECT 
		obj.ObjectPhysicalName
		,attr.AttributePhysicalName
		,tpro.RecordCount
		,cpro.ColumnCount
		,typ.name
		,ROW_NUMBER() OVER(PARTITION BY obj.ObjectID ORDER BY 
			CASE 
				WHEN typ.name LIKE '%char%' THEN 10
				WHEN col.name LIKE 'ETLAuditID' THEN 5
				WHEN col.name LIKE '%ID' AND typ.name LIKE '%int%' THEN 0
				WHEN typ.name LIKE '%int%' THEN 1
				ELSE 5 
			END) rn
		,attr.ObjectAttributeID
	FROM DQMF.dbo.MD_Database AS db
	INNER JOIN DQMF.dbo.MD_Object AS obj
		ON db.DatabaseId = obj.DatabaseId
	INNER JOIN DQMF.dbo.MD_ObjectAttribute AS attr
		ON obj.ObjectID = attr.ObjectID
	INNER JOIN AutoTest.dbo.TestConfig AS tconfig
		ON obj.ObjectID = tconfig.ObjectID
	INNER JOIN AutoTest.dbo.TableProfile AS tpro
		ON tconfig.TestConfigID = tpro.TestConfigID
	INNER JOIN AutoTest.dbo.ColumnProfile AS cpro
		ON tpro.TableProfileID = cpro.TableProfileID
			AND attr.AttributePhysicalName = cpro.ColumnName
			--JOIN AutoTest.dbo.ColumnHistogram AS chist
			--ON cpro.ColumnProfileID = chist.ColumnProfileID
	INNER JOIN sys.columns AS col
		ON attr.AttributePhysicalName = col.NAME
			AND OBJECT_NAME(col.object_id) = obj.ObjectPhysicalName
	INNER JOIN sys.types AS typ
		ON col.system_type_id = typ.system_type_id
	WHERE 1 = 1
		AND db.DatabaseName = @DatabaseName
		AND cpro.ColumnCount = tpro.RecordCount
		AND cpro.ColumnCount > 1
	) sub
	WHERE sub.rn = 1
)




