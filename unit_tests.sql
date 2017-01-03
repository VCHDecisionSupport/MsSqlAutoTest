USE AutoTest
GO

------------------------------------------------------------------
-- test: getColumns
------------------------------------------------------------------
--EXEC dbo.uspGetColumns @pDatabaseName='CommunityMart'
-- EXEC dbo.uspGetColumns @pDatabaseName='CommunityMart', @pSchemaName='dbo', @pTableName='ReferralFact';
EXEC dbo.uspGetColumns @pDatabaseName='WideWorldImportersDW', @pSchemaName='Fact', @pTableName='Sale';
GO
EXEC dbo.uspGetColumns @pDatabaseName='WideWorldImportersDW', @pSchemaName='Fact';
GO
EXEC dbo.uspGetColumns @pDatabaseName='WideWorldImportersDW';
GO
------------------------------------------------------------------
-- test: getTables
------------------------------------------------------------------
--EXEC dbo.uspGetTables @pDatabaseName='CommunityMart';
EXEC dbo.uspGetTables @pDatabaseName='WideWorldImportersDW';

------------------------------------------------------------------
-- test: uspProfileTable
------------------------------------------------------------------


--DELETE AutoTest.dbo.TableProfile;
--DELETE AutoTest.dbo.ColumnProfile;
--DELETE AutoTest.dbo.ColumnHistogram;

-- EXEC dbo.uspProfileTable @pDatabaseName='CommunityMart', @pSchemaName='dbo', @pTableName='ReferralFact';
EXEC dbo.uspProfileTable @pDatabaseName='WideWorldImportersDW', @pSchemaName='Fact', @pTableName='Sale';

SELECT *
FROM AutoTest.dbo.TableProfile;

SELECT *
FROM AutoTest.dbo.ColumnProfile;

SELECT *
FROM AutoTest.dbo.ColumnHistogram;






------------------------------------------------------------------
-- test: uspProfilePackageTables
------------------------------------------------------------------


--DELETE AutoTest.dbo.TableProfile;
--DELETE AutoTest.dbo.ColumnProfile;
--DELETE AutoTest.dbo.ColumnHistogram;

GO
DECLARE @packageName varchar(100) = 'TestPackage'
		,@databaseName varchar(100) = 'WideWorldImportersDW'
		,@schemaName varchar(100) = 'Fact'
		,@tableName varchar(100) = 'Sale'

;WITH pkg_tab AS (
	SELECT @packageName AS PackageName
		,@databaseName AS DatabaseName
		,@schemaName AS SchemaName
		,@tableName AS TableName
)
MERGE INTO AutoTest.Map.PackageTable AS dest
USING pkg_tab
ON pkg_tab.PackageName = dest.PackageName
AND pkg_tab.DatabaseName = dest.DatabaseName
AND pkg_tab.SchemaName = dest.SchemaName
AND pkg_tab.TableName = dest.TableName
WHEN NOT MATCHED THEN
INSERT (PackageName, DatabaseName, SchemaName, TableName)
VALUES (pkg_tab.PackageName, pkg_tab.DatabaseName, pkg_tab.SchemaName, pkg_tab.TableName);



GO
DECLARE @packageName varchar(100) = 'TestPackage'
		,@databaseName varchar(100) = 'WideWorldImportersDW'
		,@schemaName varchar(100) = 'Fact'
		,@tableName varchar(100) = 'Order'

;WITH pkg_tab AS (
	SELECT @packageName AS PackageName
		,@databaseName AS DatabaseName
		,@schemaName AS SchemaName
		,@tableName AS TableName
)
MERGE INTO AutoTest.Map.PackageTable AS dest
USING pkg_tab
ON pkg_tab.PackageName = dest.PackageName
AND pkg_tab.DatabaseName = dest.DatabaseName
AND pkg_tab.SchemaName = dest.SchemaName
AND pkg_tab.TableName = dest.TableName
WHEN NOT MATCHED THEN
INSERT (PackageName, DatabaseName, SchemaName, TableName)
VALUES (pkg_tab.PackageName, pkg_tab.DatabaseName, pkg_tab.SchemaName, pkg_tab.TableName);


SELECT * FROM Map.PackageTable;

-- EXEC dbo.uspProfileTable @pDatabaseName='CommunityMart', @pSchemaName='dbo', @pTableName='ReferralFact';
EXEC dbo.uspProfilePackageTables @pPackageName='TestPackage'

SELECT *
FROM AutoTest.dbo.TableProfile;

SELECT *
FROM AutoTest.dbo.ColumnProfile;

SELECT *
FROM AutoTest.dbo.ColumnHistogram;

