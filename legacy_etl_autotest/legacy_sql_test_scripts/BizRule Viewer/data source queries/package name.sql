SELECT PkgID, PkgName, UpdatedBy
FROM dbo.ETL_Package AS pkg
WHERE 1=1
AND pkg.isActive = 1
ORDER BY pkg.UpdatedDT DESC, pkg.CreatedDT

