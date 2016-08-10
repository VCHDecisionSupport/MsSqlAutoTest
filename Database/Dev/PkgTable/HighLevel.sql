USE DQMF
GO

SELECT COUNT(*) AS FactTableCount
FROM gcMD_Object AS obj
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'

SELECT COUNT(*) AS FactsWoPkg
FROM gcMD_Object AS obj
FULL JOIN tab
ON obj.ObjectPhysicalName = tab.TableName
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
AND tab.PkgName IS NULL


SELECT COUNT(DISTINCT PkgName) AS PkgCount, ObjectPhysicalName AS TableWMultiPkg 
FROM gcMD_Object AS obj
FULL JOIN tab
ON obj.ObjectPhysicalName = tab.TableName
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
AND tab.PkgName IS NOT NULL
GROUP BY ObjectPhysicalName
HAVING COUNT(DISTINCT PkgName) > 1
ORDER BY ObjectPhysicalName




SELECT pkgmap.ParentPkgName, pkgmap.ChildPkgName, ObjectPhysicalName AS TableWMultiPkg 
FROM gcMD_Object AS obj
FULL JOIN tab
ON obj.ObjectPhysicalName = tab.TableName
JOIN ETL_ParentChildPackage AS pkgmap
ON tab.PkgName = pkgmap.ParentPkgName
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
GROUP BY pkgmap.ParentPkgName, pkgmap.ChildPkgName, ObjectPhysicalName, CASE WHEN tab.PkgName IS NULL THEN 0 ELSE 1 END
ORDER BY CASE WHEN tab.PkgName IS NULL THEN 0 ELSE 1 END ASC, ObjectPhysicalName


SELECT COUNT(DISTINCT obj.ObjectID) AS TableCount, ObjectSchemaName, tab.PkgName
FROM gcMD_Object AS obj
LEFT JOIN tab
ON obj.ObjectPhysicalName LIKE tab.TableName
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
AND obj.ObjectSchemaName != 'Dim'
GROUP BY ObjectSchemaName, tab.PkgName
ORDER BY ObjectSchemaName


SELECT DISTINCT tab.PkgName, obj.ObjectPhysicalName, *
FROM gcMD_Object AS obj
LEFT JOIN tab
ON obj.ObjectPhysicalName LIKE tab.TableName
WHERE 1=1
AND obj.IsActive = 1
AND obj.DatabaseId > 1
AND obj.IsObjectInDB = 1
AND obj.SubjectAreaID != 0
AND obj.ObjectType = 'Table'
AND obj.ObjectPhysicalName LIKE '%fact'
AND obj.ObjectSchemaName != 'Staging'
AND obj.ObjectSchemaName != 'Dim'
ORDER BY tab.PkgName, obj.ObjectPhysicalName

