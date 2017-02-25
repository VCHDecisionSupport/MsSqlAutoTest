USE msdb
GO


IF  NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vwPackagePath', 'V'))
BEGIN
	EXEC ('CREATE VIEW dbo.vwPackagePath AS SELECT 1 AS one;');
END
GO

/****** Object:  StoredProcedure dbo.vwPackagePath   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER VIEW dbo.vwPackagePath
AS
WITH msdb_folders AS
(
	SELECT rootpkg.parentfolderid, 
		rootpkg.folderid, 
		rootpkg.foldername, 
		0 AS level, 
		CAST('MSDB' AS varchar(500)) as full_path 
	FROM msdb.dbo.sysssispackagefolders AS rootpkg 
	WHERE parentfolderid IS NULL
	UNION ALL
	SELECT 
		childpkg.parentfolderid, 
		childpkg.folderid, 
		childpkg.foldername, 
		recurse.level + 1 as level, 
		CAST(recurse.full_path + '\' + childpkg.foldername AS varchar(500)) AS full_path 
	FROM msdb.dbo.sysssispackagefolders AS childpkg 
	JOIN msdb_folders as recurse
	ON childpkg.ParentFolderID = recurse.folderid
	WHERE childpkg.parentfolderid IS NOT NULL
)
SELECT 
	msdb_folders.full_path AS PackageFolderPath
	,msdb_folders.full_path + '\' + pkgs.name AS PackageFullPath
	,pkgs.name AS PackageName
FROM msdb_folders
JOIN msdb.dbo.sysssispackages as pkgs
ON msdb_folders.folderid = pkgs.folderid
GO	


-- DECLARE @NumberOfProfilesToKeep int = 5;
-- SELECT *
-- FROM AutoTest.dbo.vwPackagePath
-- WHERE ProfileRelativeAge > @NumberOfProfilesToKeep
-- ORDER BY PkgExecKey
-- 	,DatabaseName
-- 	,SchemaName
-- 	,TableName
-- 	,TableProfileDate DESC