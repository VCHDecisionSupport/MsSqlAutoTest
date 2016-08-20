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

--SELECT ObjectID, *
--FROM DQMF.dbo.MD_Object
--WHERE 1=1
--AND databaseid != @DatabaseID
--AND ObjectPurpose = 'Fact'
--AND ObjectPKField NOT LIKE 'ETLAuditId'
--AND ObjectPKField != ''
--AND ObjectPhysicalName = 'SchoolHistoryFact'
-- 53085

--SELECT * FROM AutoTest.dbo.TestType;
-- 3

--INSERT INTO DQMF.dbo.ETL_PackageObject (PackageID, ObjectID, TestTypeID) VALUES (@PackageID, @ObjectID, @TestTypeID)

DELETE DQMF.dbo.ETL_PackageObject
WHERE 1=1
AND PackageID = @PackageID
--AND ObjectID IN (53895,53913,53896)


;WITH src AS (
	SELECT TOP 10 *
	FROM DQMF.dbo.MD_Object AS obj
	WHERE obj.databaseid = @DatabaseID
	AND obj.ObjectPurpose = 'Fact'
	AND obj.ObjectPKField NOT LIKE 'ETLAuditId'
	AND obj.ObjectPhysicalName = 'RaiHCAssessmentFact'
	AND obj.ObjectID IN (
		SELECT ObjectID
		FROM DQMF.dbo.MD_ObjectAttribute attr
		WHERE attr.AttributePhysicalName = 'ETLAuditID'
	)
)
MERGE INTO DQMF.dbo.ETL_PackageObject AS dest
USING src
ON src.ObjectID = dest.ObjectID
WHEN NOT MATCHED THEN INSERT 
VALUES (@PackageID, src.ObjectID, @TestTypeID);

--DELETE DQMF.dbo.ETL_PackageObject
--WHERE 1=1
--AND PackageID = @PackageID
--AND ObjectID IN (53895,53913,53896)
--OR ObjectID != 53894

SELECT *
FROM DQMF.dbo.ETL_PackageObject map
JOIN DQMF.dbo.MD_Object obj
ON obj.ObjectID = map.OBjectID
JOIN DQMF.dbo.ETL_PAckage pkg
ON map.PackageID = pkg.Pkgid

--#region diff maker loop
DECLARE diffCursor CURSOR
FOR
SELECT db.databasename, obj.ObjectSchemaName, obj.ObjectPhysicalName
FROM DQMF.dbo.ETL_PackageObject AS pkg
JOIN DQMF.dbo.MD_Object obj
ON obj.ObjectID = pkg.OBjectID
JOIN DQMF.dbo.MD_Database db
ON obj.Databaseid = db.DatabaseId

OPEN diffCursor;

DECLARE @RC int
DECLARE @pDatabaseName nvarchar(200) = 'CommunityMart'
DECLARE @pSchemaName nvarchar(200) = 'dbo'
DECLARE @pObjectName nvarchar(200) = 'SchoolHistoryFact'
DECLARE @pPercentError int

FETCH NEXT FROM diffCursor INTO @pDatabaseName, @pSchemaName, @pObjectName

-- TODO: Set parameter values here.
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @pDatabaseName;
	PRINT @pSchemaName;
	PRINT @pObjectName;

	--EXECUTE @RC = AutoTest.[dbo].[uspDiffMaker] 
	--   @pDatabaseName
	--  ,@pSchemaName
	--  ,@pObjectName
	--  ,@pPercentError
	FETCH NEXT FROM diffCursor INTO @pDatabaseName, @pSchemaName, @pObjectName

END

CLOSE diffCursor
DEALLOCATE diffCursor;
--#endregion diff maker loop

