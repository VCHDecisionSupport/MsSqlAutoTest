USE AutoTest
GO


IF  NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vwProfileAge', 'V'))
BEGIN
	EXEC ('CREATE VIEW dbo.vwProfileAge AS SELECT 1 AS one;');
END
GO

/****** Object:  StoredProcedure dbo.vwProfileAge   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
ALTER VIEW dbo.vwProfileAge
AS
WITH Profiles AS (
SELECT 
	DatabaseName
	,SchemaName
	,TableName
	,PkgExecKey
	,TableProfileDate
	,ProfileID
	,ROW_NUMBER() OVER (
		PARTITION BY PkgExecKey
			,DatabaseName
			,SchemaName
			,TableName
		ORDER BY
			ProfileID DESC
		) AS ProfileRelativeAge
FROM AutoTest.dbo.TableProfile
)
SELECT *
FROM Profiles;
GO	


DECLARE @NumberOfProfilesToKeep int = 5;
SELECT *
FROM AutoTest.dbo.vwProfileAge
WHERE ProfileRelativeAge > @NumberOfProfilesToKeep
ORDER BY PkgExecKey
	,DatabaseName
	,SchemaName
	,TableName
	,TableProfileDate DESC