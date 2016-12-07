SELECT DISTINCT sch.StageID, StageName, pkg.UpdatedDT
FROM dbo.ETL_Package AS pkg
JOIN dbo.DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
JOIN dbo.DQMF_Stage AS stg
ON sch.StageID = stg.StageID
WHERE 1=1
AND pkg.isActive = 1
ORDER BY pkg.UpdatedDT DESC

