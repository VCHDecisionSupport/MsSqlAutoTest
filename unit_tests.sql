USE AutoTest
GO
SELECT * FROM AutoTest.dbo.TableProfile;
SELECT * FROM AutoTest.dbo.ColumnProfile;
SELECT * FROM AutoTest.dbo.ColumnHistogram;
SELECT * FROM AutoTest.Map.PackageTable;

DELETE AutoTest.dbo.TableProfile;
DELETE AutoTest.dbo.ColumnProfile;
DELETE AutoTest.dbo.ColumnHistogram;
DELETE AutoTest.Map.PackageTable
WHERE DatabaseName LIKE '[SourceDataArchive]'
OR SchemaName LIKE '%Staging%'
OR TableName LIKE '%Staging%'
OR SchemaName LIKE '%Staging%'
------------------------------------------------------------------
-- test: getColumns
------------------------------------------------------------------
--EXEC dbo.uspGetColumns @pDatabaseName='CommunityMart'
DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='dbo', @pTableName varchar(100) ='ReferralFact';
EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName;
GO
DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='dbo', @pTableName varchar(100) ='ReferralFact';
EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName;
GO
DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='dbo', @pTableName varchar(100) ='ReferralFact';
EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName;
GO
------------------------------------------------------------------
-- test: getTables
------------------------------------------------------------------
--EXEC dbo.uspGetTables @pDatabaseName='CommunityMart';
DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='dbo', @pTableName varchar(100) ='ReferralFact';
EXEC dbo.uspGetTables @pDatabaseName=@pDatabaseName;
GO

------------------------------------------------------------------
-- test: uspProfileTable
------------------------------------------------------------------

DELETE AutoTest.dbo.TableProfile;
DELETE AutoTest.dbo.ColumnProfile;
DELETE AutoTest.dbo.ColumnHistogram;
GO

DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='Dim', @pTableName varchar(100) ='ReferralType';
EXEC AutoTest.dbo.uspProfileTable @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName;
GO
DECLARE @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='Dim', @pTableName varchar(100) ='ReferralType';
EXEC AutoTest.dbo.uspProfileTable @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName, @pLogResults = 0;
GO
SELECT * FROM AutoTest.dbo.TableProfile;
SELECT * FROM AutoTest.dbo.ColumnProfile;
SELECT * FROM AutoTest.dbo.ColumnHistogram;

------------------------------------------------------------------
-- test: uspInsMapPackageTable
------------------------------------------------------------------

DECLARE @pPackageName varchar(100) ='gcTestMapping', @pDatabaseName varchar(100) ='CommunityMart', @pSchemaName varchar(100) ='Dim', @pTableName varchar(100) ='ReferralType';
EXEC AutoTest.dbo.uspInsMapPackageTable @pPackageName=@pPackageName, @pDatabaseName=@pDatabaseName, @pSchemaName=@pSchemaName, @pTableName=@pTableName;
SELECT * FROM AutoTest.Map.PackageTable;
GO

------------------------------------------------------------------
-- test: uspProfilePackageTables
------------------------------------------------------------------

-- 1. clean tables
DELETE AutoTest.dbo.TableProfile;
DELETE AutoTest.dbo.ColumnProfile;
DELETE AutoTest.dbo.ColumnHistogram;
DELETE AutoTest.Map.PackageTable;

USE master
GO
-- 2. create mock database
IF DB_ID('gcTestData') IS NOT NULL
DROP DATABASE gcTestData;
GO
CREATE DATABASE gcTestData;
GO
USE gcTestData
GO
CREATE SCHEMA Dim;
GO
USE AutoTest
GO

SELECT * INTO gcTestData.Dim.Date
FROM CommunityMart.Dim.Date;

SELECT * INTO gcTestData.Dim.LocalReportingOffice
FROM CommunityMart.Dim.LocalReportingOffice;

SELECT * INTO gcTestData.dbo.ReferralWaitTimeFact
FROM CommunityMart.dbo.ReferralWaitTimeFact;

SELECT * INTO gcTestData.dbo.ReferralFact
FROM CommunityMart.dbo.ReferralFact;

-- 3. map mock data to mock package
INSERT INTO AutoTest.Map.PackageTable
SELECT 
	'gcTestPackage' AS PackageName
	,'gcTestData' AS DatabaseName
	,sch.name AS SchemaName
	,tab.name AS TableName
	,1 AS IsTableProfiled
FROM gcTestData.sys.tables AS tab
JOIN gcTestData.sys.schemas AS sch
ON tab.schema_id=sch.schema_id

-- turn off profiling for a table
UPDATE AutoTest.Map.PackageTable
SET IsProfilingOn = 0
FROM AutoTest.Map.PackageTable AS pkg
WHERE pkg.TableName = 'ReferralFact';
GO
SELECT * FROM AutoTest.Map.PackageTable;
GO

-- 4. test uspProfilePackageTables
EXEC dbo.uspProfilePackageTables @pPackageName='gcTestPackage';
GO

SELECT * FROM AutoTest.dbo.vwProfileAge;
SELECT * FROM AutoTest.dbo.TableProfile;
SELECT * FROM AutoTest.dbo.ColumnProfile;
SELECT * FROM AutoTest.dbo.ColumnHistogram;
GO

------------------------------------------------------------------
-- test: DQMF.dbo.SetAuditPkgExecution
------------------------------------------------------------------
USE DQMF
GO

DELETE dbo.ETL_Package WHERE PkgName = 'gcTestPackage';
INSERT INTO dbo.ETL_Package 
(
	PkgName
	,PkgDescription
	,CreatedBy
	,CreatedDT
	,UpdatedBy
	,UpdatedDT
)
VALUES
(
	'gcTestPackage'
	,'PkgDescription'
	,'CreatedBy'
	,'1999-12-31'
	,'UpdatedBy'
	,'1999-12-31'
)

DECLARE @pPkgExecKeyout  bigint

EXEC [SetAuditPkgExecution]
	@pPkgExecKey = null
	,@pParentPkgExecKey = null
	,@pPkgName = 'gcTestPackage'
	,@pPkgVersionMajor = 1
	,@pPkgVersionMinor  = 1
	,@pIsProcessStart  = 1
	,@pIsPackageSuccessful  = 0
	,@pPkgExecKeyout  = @pPkgExecKeyout   output

EXEC [SetAuditPkgExecution]
	@pPkgExecKey = @pPkgExecKeyout
	,@pParentPkgExecKey = null
	,@pPkgName = 'gcTestPackage'
	,@pPkgVersionMajor = 1
	,@pPkgVersionMinor  = 1
	,@pIsProcessStart  = 0
	,@pIsPackageSuccessful  = 1
	,@pPkgExecKeyout  = @pPkgExecKeyout   output
GO

SELECT * FROM AutoTest.dbo.vwProfileAge;
SELECT * FROM AutoTest.dbo.TableProfile;
SELECT * FROM AutoTest.dbo.ColumnProfile;
SELECT * FROM AutoTest.dbo.ColumnHistogram;
GO