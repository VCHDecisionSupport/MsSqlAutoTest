USE [gcDev]
GO

IF OBJECT_ID('dbo.vwDiff','V') IS NOT NULL
DROP VIEW dbo.vwDiff;
GO

CREATE VIEW [dbo].[vwDiff] 
AS
WITH sql AS (
SELECT 
	test.*
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension0Name ELSE test.Dimension1Name END AS DimensionAName
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension0Value ELSE test.Dimension1Value END AS DimensionAValue
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension1Name ELSE test.Dimension0Name END AS DimensionBName
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension1Value ELSE test.Dimension0Value END AS DimensionBValue
FROM dbo.CubeUnitTest test
WHERE 1=1
--AND test.IsMostRecentTest = 1
AND test.TestResultSource LIKE '%DBDECSUP%'
), mdx AS (
SELECT 
	test.*
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension0Name ELSE test.Dimension1Name END AS DimensionAName
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension0Value ELSE test.Dimension1Value END AS DimensionAValue
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension1Name ELSE test.Dimension0Name END AS DimensionBName
	,CASE WHEN test.Dimension0Name < test.Dimension1Name THEN test.Dimension1Value ELSE test.Dimension0Value END AS DimensionBValue
FROM dbo.CubeUnitTest test
WHERE 1=1
--AND test.IsMostRecentTest = 1
AND test.TestResultSource NOT LIKE '%DBDECSUP%'
)
SELECT 
	mdx.CubeName
	,mdx.MeasureName
	,mdx.MeasureValue AS CubeMeasureValue
	,sql.MeasureValue AS SqlMeasureValue
	,mdx.MeasureValue - sql.MeasureValue AS [AbsDelta]
	,CAST(ROUND(ABS((mdx.MeasureValue - sql.MeasureValue)/((mdx.MeasureValue + sql.MeasureValue)/2)),3)*100 AS float) AS [RelDelta]
	,mdx.DimensionAName
	,mdx.DimensionAValue
	,mdx.DimensionBName
	,mdx.DimensionBValue
	,mdx.CubeProcessDate
	,mdx.TestResultDate

FROM sql
JOIN mdx
ON sql.CubeName LIKE mdx.CubeName
AND sql.MeasureName LIKE mdx.MeasureName
AND sql.DimensionAName LIKE mdx.DimensionAName
AND sql.DimensionAValue LIKE mdx.DimensionAValue
AND sql.DimensionBName LIKE mdx.DimensionBName
AND sql.DimensionBValue LIKE mdx.DimensionBValue


GO


