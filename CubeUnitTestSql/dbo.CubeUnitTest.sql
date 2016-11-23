USE CubeUnitTest
GO

IF OBJECT_ID('dbo.CubeUnitTest','U') IS NOT NULL
	DROP TABLE dbo.CubeUnitTest;
GO

CREATE TABLE dbo.CubeUnitTest(
	CubeName varchar(100),
	TestResultSource varchar(100),
	TestResultDate date,
	Dimension0Name varchar(100),
	Dimension0Value varchar(100),
	Dimension1Name varchar(100),
	Dimension1Value varchar(100),
	MeasureName varchar(100),
	MeasureValue numeric(15,3)
);
GO

IF(OBJECT_ID('dbo.uspInsertCubeUnitTestResults','P') IS NOT NULL)
	DROP PROC dbo.uspInsertCubeUnitTestResults
GO

IF (SELECT 1 FROM sys.table_types obj WHERE obj.name = 'CubeUnitTestType') IS NOT NULL
	DROP TYPE dbo.CubeUnitTestType;
GO

CREATE TYPE dbo.CubeUnitTestType AS TABLE (
	Dimension0Value varchar(100),
	Dimension1Value varchar(100),
	MeasureValue varchar(100)
);
GO

CREATE PROC dbo.uspInsertCubeUnitTestResults 
	@CubeName AS varchar(100)
	,@TestResultSource AS varchar(100)
	,@Dimension0Name AS varchar(100)
	,@Dimension1Name AS varchar(100)
	,@MeasureName AS varchar(100)
	,@CubeUnitTestResults AS dbo.CubeUnitTestType READONLY
AS
BEGIN
	DECLARE @TestResultDate date = GETDATE();

	INSERT INTO dbo.CubeUnitTest (
		CubeName
		,TestResultSource
		,TestResultDate
		,Dimension0Name
		,Dimension0Value
		,Dimension1Name
		,Dimension1Value
		,MeasureName
		,MeasureValue)
	SELECT 
		@CubeName AS CubeName
		,@TestResultSource AS TestResultSource
		,@TestResultDate AS TestResultDate
		,@Dimension0Name AS Dimension0Name
		,Dimension0Value AS Dimension0Value
		,@Dimension1Name AS Dimension1Name
		,Dimension1Value AS Dimension1Value
		,@MeasureName AS MeasureName
		,CAST(MeasureValue AS numeric(15,3)) AS MeasureValue
	FROM @CubeUnitTestResults;
END
GO
SELECT * FROM dbo.CubeUnitTest;

GO
CREATE VIEW dbo.vwDiff 
AS
WITH sql AS (
SELECT 
	test.CubeName as x
FROM dbo.CubeUnitTest test
), mdx AS (
SELECT 
	test.CubeName
FROM dbo.CubeUnitTest test
)
SELECT *
FROM sql
JOIN mdx
ON sql.x = mdx.CubeName

GO