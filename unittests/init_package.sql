DELETE DQMF.dbo.ETL_PackageObject;

DECLARE @PkgName varchar(500) = 'AutoTestTesting3'
DECLARE @DatabaseName varchar(500) = 'HCRSMart'
DECLARE @PackageID int = 333;
DECLARE @DatabaseID int = 25;
DECLARE @ObjectID int = 53085;
DECLARE @TestTypeID int = 3;

MERGE INTO DQMF.dbo.ETL_Package AS dest
USING (VALUES(@PkgName)) newPkg(PkgName)
ON dest.PkgName = newPkg.PkgName
WHEN NOT MATCHED 
THEN INSERT (PkgName, PkgDescription, CreatedBy, CreatedDT, UpdatedBy, UpdatedDt) VALUES (@PkgName, 'This is a mock up package to test the AutoTest framework', CURRENT_USER, GETDATE(), CURRENT_USER, GETDATE());

SELECT @PackageID = PkgId
FROM DQMF.dbo.ETL_Package
WHERE PkgName = @PkgName
-- 333

SELECT @DatabaseID = DatabaseId
FROM DQMF.dbo.MD_Database
WHERE DatabaseName = @DatabaseName

DELETE DQMF.dbo.ETL_PackageObject
WHERE 1=1
AND PackageID = @PackageID


;WITH src AS (
	SELECT TOP 5 *
	FROM DQMF.dbo.MD_Object AS obj
	WHERE 1=1
	--AND obj.databaseid = @DatabaseID
	--AND obj.databaseid = 25
	AND obj.ObjectPurpose = 'Fact'
	AND obj.ObjectPKField NOT LIKE 'ETLAuditId'
	--AND obj.ObjectPhysicalName = 'RaiHCAssessmentFact'
	--AND ObjectID NOT IN (1261,1262)
	AND obj.ObjectID IN (
		SELECT ObjectID
		FROM DQMF.dbo.MD_ObjectAttribute attr
		WHERE attr.AttributePhysicalName = 'ETLAuditID'
	)
	ORDER BY NEWID()
)
MERGE INTO DQMF.dbo.ETL_PackageObject AS dest
USING src
ON src.ObjectID = dest.ObjectID
WHEN NOT MATCHED THEN INSERT 
VALUES (@PackageID, src.ObjectID, @TestTypeID);

SELECT db.DatabaseName, obj.ObjectSchemaName, obj.ObjectPhysicalName, obj.ObjectID, db.DatabaseId, pkg.PkgID
FROM DQMF.dbo.ETL_PackageObject map
JOIN DQMF.dbo.MD_Object obj
ON obj.ObjectID = map.OBjectID
JOIN DQMF.dbo.ETL_PAckage pkg
ON map.PackageID = pkg.Pkgid
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseID = db.DAtabaseID
--WHERE PackageID = @PackageID

