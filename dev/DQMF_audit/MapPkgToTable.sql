--USE DQMF
--GO

--SELECT obj.ObjectType, COUNT(*) AS rcnt
--FROM MD_Object AS obj
--WHERE 1=1
--AND obj.IsActive = 1
--GROUP BY obj.ObjectType
---- well populated

--SELECT obj.ObjectPurpose, COUNT(*) AS rcnt
--FROM MD_Object AS obj
--WHERE 1=1
--AND obj.IsActive = 1
--GROUP BY obj.ObjectPurpose
---- poorly populated

--SELECT obj.ObjectPurpose, COUNT(*) AS rcnt
--FROM MD_Object AS obj
--WHERE 1=1
--AND obj.IsActive = 1
--GROUP BY obj.ObjectType, obj.ObjectPurpose
--ORDER BY COUNT(*) DESC

--DELETE gcMD_Object
--SELECT *
--FROM gcMD_Object

SELECT *
--INTO gcNoPkg
FROM gcMD_Object AS obj
--FULL JOIN DQMF_BizRule AS br
--ON br.TargetObjectPhysicalName = obj.ObjectPhysicalName
FULL JOIN tab
ON obj.ObjectPhysicalName = tab.TableName
WHERE 1=1
AND obj.IsActive = 1
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
AND tab.PkgName IS NULL
--AND br.BRId IS NULL


