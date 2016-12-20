USE msdb
GO

IF OBJECT_ID('dbo.vwPackagePathes') IS NOT NULL
BEGIN
	DROP VIEW dbo.vwPackagePathes;
END
GO

CREATE VIEW dbo.vwPackagePathes
AS
WITH msdb_folders AS
(
	SELECT rootpkg.parentfolderid, 
		rootpkg.folderid, 
		rootpkg.foldername, 
		0 AS level, 
		CAST('\' AS varchar(500)) as full_path 
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
FROM msdb_folders
JOIN msdb.dbo.sysssispackages as pkgs
ON msdb_folders.folderid = pkgs.folderid
GO

