USE AutoTest
GO

/*
2017-02-27 Graham Crowell DR9581 initial deployment
*/

IF  NOT EXISTS (SELECT TOP 1 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.vwProfileAge', 'V'))
BEGIN
	EXEC ('CREATE VIEW dbo.vwProfileAge AS SELECT 1 AS one;');
END
GO

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
		PARTITION BY
			DatabaseName
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

