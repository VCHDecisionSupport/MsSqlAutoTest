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
-- test: uspInsTableProfile
------------------------------------------------------------------
DECLARE @pProfileDate smalldatetime = GETDATE();
DECLARE @pProfileDateIsoStr varchar(23) = CONVERT(varchar(22), @pProfileDate, 126);
SELECT @pProfileDate AS pProfileDate, @pProfileDateIsoStr AS IsoDateFormat
EXEC AutoTest.dbo.uspInsTableProfile @pProfileDateIsoStr = @pProfileDateIsoStr, @pPackageName = 'sfs', @pDatabaseName = 'sdfs', @pSchemaName = 'sch', @pTableName = 'tab', @pRowCount = 123, @pPkgExecKey = 549;
SELECT * FROM AutoTest.dbo.TableProfile;


------------------------------------------------------------------
-- 1 setup: create mock database with data
------------------------------------------------------------------

-- A. clean tables
DELETE AutoTest.dbo.TableProfile;
DELETE AutoTest.dbo.ColumnProfile;
DELETE AutoTest.dbo.ColumnHistogram;
DELETE AutoTest.Map.PackageTable;

USE master
GO
-- B. create mock database
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

-- C. map mock data to mock package
INSERT INTO AutoTest.Map.PackageTable 
(
	PackageName
	,DatabaseName
	,SchemaName
	,TableName
)
SELECT 
	'gcTestPackage' AS PackageName
	,'gcTestData' AS DatabaseName
	,sch.name AS SchemaName
	,tab.name AS TableName
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

-- D. profile data (uspProfilePackageTables or DQMF.dbo.SetAuditPkgExecution)

------------------------------------------------------------------
-- 2 setup: randomly change table data (mock etl)
------------------------------------------------------------------

USE gcTestData
GO

SELECT TOP 5 PERCENT *
FROM gcTestData.Dim.LocalReportingOffice AS lro_dim

-- delete records
;WITH del_ids AS (
	SELECT TOP 10 LocalReportingOfficeID 
	FROM gcTestData.Dim.LocalReportingOffice 
	ORDER BY NEWID()
)
DELETE del_tab
FROM gcTestData.Dim.LocalReportingOffice AS del_tab
JOIN del_ids
ON del_tab.LocalReportingOfficeID = del_ids.LocalReportingOfficeID


-- insert records
;WITH ins_ids AS (
	SELECT TOP 30 PERCENT LocalReportingOfficeID 
	FROM gcTestData.Dim.LocalReportingOffice 
	ORDER BY NEWID()
	-- UNION
	-- SELECT TOP 20 PERCENT LocalReportingOfficeID 
	-- FROM gcTestData.Dim.LocalReportingOffice 
	-- ORDER BY NEWID()
	-- UNION
	-- SELECT TOP 20 PERCENT LocalReportingOfficeID 
	-- FROM gcTestData.Dim.LocalReportingOffice 
	-- ORDER BY NEWID()
)
INSERT INTO gcTestData.Dim.LocalReportingOffice
SELECT 
	del_tab.LocalReportingOfficeID*-1 AS LocalReportingOfficeID
	,CommunityProgramID
	,ParisTeamKey
	,ParisTeamCode
	,ParisTeamName
	,PostalCode
	,City
	,CommunityLHAID
	,CommunityRegionID
	,IsAmbulatoryService
	,ParisTeamGroup
	,LROSubProgram
	,IsTCUTeam
	,IsALTeam
	,ProviderID
	,IsHCCMRRExclude
	,IsPriorityAccess
FROM gcTestData.Dim.LocalReportingOffice AS del_tab
JOIN ins_ids
ON del_tab.LocalReportingOfficeID = ins_ids.LocalReportingOfficeID
----------------------------------------------------



------------------------------------------------------------------
-- test: uspProfilePackageTables
------------------------------------------------------------------
USE AutoTest
GO
EXEC dbo.uspProfilePackageTables @pPackageName='gcTestPackage',@pPkgExecKey=123;;
GO


SELECT * FROM AutoTest.dbo.vwProfileAge;
SELECT * FROM AutoTest.dbo.TableProfile;
SELECT * FROM AutoTest.dbo.ColumnProfile
WHERE TableName = 'LocalReportingOffice'
ORDER BY ColumnName, ProfileID
SELECT * FROM AutoTest.dbo.ColumnHistogram
WHERE TableName = 'LocalReportingOffice'
ORDER BY ColumnName, ColumnValue, ProfileID

GO

------------------------------------------------------------------
-- test: DQMF.dbo.SetAuditPkgExecution
------------------------------------------------------------------
USE DQMF
GO

DECLARE @pPkgName varchar(500)  = 'PopulateCommunityMart'
DECLARE @pPkgExecKeyout  bigint

EXEC DQMF.dbo.[SetAuditPkgExecution]
	@pPkgExecKey = null
	,@pParentPkgExecKey = null
	,@pPkgName = @pPkgName
	,@pPkgVersionMajor = 1
	,@pPkgVersionMinor  = 1
	,@pIsProcessStart  = 1
	,@pIsPackageSuccessful  = 0
	,@pPkgExecKeyout  = @pPkgExecKeyout   output

EXEC DQMF.dbo.[SetAuditPkgExecution]
	@pPkgExecKey = @pPkgExecKeyout
	,@pParentPkgExecKey = null
	,@pPkgName = @pPkgName
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
SELECT * FROM AutoTest.Map.PackageTable;

GO
