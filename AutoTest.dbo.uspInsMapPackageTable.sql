USE AutoTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspInsMapPackageTable') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspInsMapPackageTable AS');
END
GO

/****** Object:  StoredProcedure dbo.uspInsMapPackageTable   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspInsMapPackageTable
	@pPackageName varchar(500), 
	@pDatabaseName varchar(500),
	@pSchemaName varchar(500),
	@pTableName varchar(500)
AS
BEGIN
	WITH pkg_tab AS (
		SELECT @pPackageName AS PackageName
			,@pDatabaseName AS DatabaseName
			,@pSchemaName AS SchemaName
			,@pTableName AS TableName
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
END