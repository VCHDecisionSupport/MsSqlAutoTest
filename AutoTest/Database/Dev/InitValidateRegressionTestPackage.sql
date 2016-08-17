DECLARE @ObjectID int = 53898 -- schoolhistoryfact
DECLARE @PackageID int;

-- insert package in to DQMF
--INSERT INTO DQMF.dbo.ETL_Package (
--	[PkgName]
--	,[PkgDescription]
--	,[CreatedBy]
--	,[CreatedDT]
--	,[UpdatedBy]
--	,[UpdatedDT]
--	,[IsLocking]
--	,[isActive]
--)
--VALUES (
--	'ValidateRegressionTest'
--	,'This is a mock ETL package used to validate AutoTest'
--	,'gcrowell'
--	,GETDATE()
--	,'gcrowell'
--	,GETDATE()
--	,0
--	,1
--)
--SET @PackageID = @@IDENTITY

SET @PackageID = 328
-- insert table into DQMF
--INSERT INTO DQMF.dbo.ETL_PackageObject (
--	PackageID
--	,ObjectID
--)
--VALUES (
--	@PackageID
--	,@ObjectID
--)

-- insert table into AutoTest
INSERT INTO AutoTest.dbo.TestConfig(
	TestTypeID
	,ObjectID
	,PkgID
	,TestConfigSourceID
)
VALUES (
	2 --RuntimeRegressionTest
	,@ObjectID
	,@PackageID
	,1 -- User Specified
)