--USE DQMF
--GO



--SELECT 
--	COUNT(*) as rwcnt
--	,CASE WHEN db.DatabaseName = 'CommunityMart' OR obj.ObjectSchemaName = 'Community' THEN 1 ELSE 0 END IsCommunity
--	,CASE WHEN obj.ObjectPKField LIKE 'etlauditid'	THEN 1 ELSE 0 END IsEtlKey
--	--,db.DatabaseName
--	--,obj.ObjectSchemaName
--	--,obj.ObjectPhysicalName
--FROM MD_Object AS obj
--JOIN MD_Database AS db
--ON obj.DatabaseId = db.DatabaseId
--WHERE 1=1
--AND obj.ObjectPurpose = 'Fact'
--GROUP BY 
--CASE WHEN db.DatabaseName = 'CommunityMart' OR obj.ObjectSchemaName = 'Community'	THEN 1 ELSE 0 END
--,CASE WHEN obj.ObjectPKField LIKE 'etlauditid'	THEN 1 ELSE 0 END


SELECT *
FROM MD_Object AS obj
JOIN MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
WHERE 1=1
AND obj.ObjectPurpose = 'Fact'
AND obj.ObjectType = 'Table'
AND obj.IsActive = 1
AND obj.IsObjectInDB = 1
AND db.IsActive = 1
AND (db.DatabaseName = 'DSDW' OR db.DatabaseName LIKE '%mart')
AND (obj.ObjectSchemaName != 'Staging')
--AND obj.ObjectPKField is not null
--AND CHARINDEX(',',obj.ObjectPKField,1) > 0