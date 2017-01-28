USE AutoTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspGetPackagePath') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspGetPackagePath AS');
END
GO

/****** Object:  StoredProcedure dbo.uspGetPackagePath   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER PROCEDURE dbo.uspGetPackagePath
	@pPackageName varchar(500) = NULL
AS
BEGIN
	SELECT PackageFolderPath
		,PackageFullPath
		,PackageName
	FROM msdb.dbo.vwPackagePath
	WHERE 1=1
	AND ISNULL(@pPackageName, PackageName) = PackageName;
END