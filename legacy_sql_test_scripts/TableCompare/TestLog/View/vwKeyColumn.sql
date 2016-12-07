USE TestLog
GO

IF OBJECT_ID('dbo.vwKeyColumnCompare','V') IS NOT NULL
	DROP VIEW dbo.vwKeyColumnCompare;
GO
CREATE VIEW dbo.vwKeyColumnCompare
AS
WITH 
	mid AS (
	SELECT comp.ComparisonDate
		,comp.IntersectionCount
		,comp.KeyComparisonID
		,comp.SUserLogin
	FROM TestLog.dbo.KeyComparison AS comp
	--JOIN TestLog.dbo.KeyColumn AS col
	--ON col.KeyComparisonID = comp.KeyComparisonID
),
lhs AS (
	SELECT 
		comp.ComparisonDate
		,col.KeyColumnDatabaseName + 
		'.'+col.KeyColumnSchemaName +
		'.'+col.KeyColumnTableName AS TableName
		,col.KeyColumnDatabaseName 
		,col.KeyColumnSchemaName
		,col.KeyColumnTableName
		,col.KeyColumnName
		,col.KeyColumnID
		,col.KeyComparisonID
		,col.SetDifferenceCount
		,col.DuplicateCount
		,ROW_NUMBER() OVER(PARTITION BY comp.KeyComparisonID ORDER BY comp.KeyComparisonID) AS rn
		,ROW_NUMBER() OVER(PARTITION BY comp.KeyComparisonID 
			ORDER BY comp.KeyComparisonID,
			CASE 
				WHEN col.KeyColumnSchemaName = 'Staging' THEN 1 
				WHEN col.KeyColumnDatabaseName = 'DSDW' THEN 2
				ELSE 3
			END) AS DataFlow
	FROM TestLog.dbo.KeyComparison comp
	JOIN TestLog.dbo.KeyColumn col
	ON col.KeyComparisonID = comp.KeyComparisonID
), rhs AS (
	SELECT 
		comp.ComparisonDate
		,col.KeyColumnDatabaseName + 
		'.'+col.KeyColumnSchemaName +
		'.'+col.KeyColumnTableName AS TableName
		,col.KeyColumnDatabaseName 
		,col.KeyColumnSchemaName
		,col.KeyColumnTableName
		,col.KeyColumnName
		,col.KeyColumnID
		,col.KeyComparisonID
		,col.SetDifferenceCount
		,col.DuplicateCount
		,ROW_NUMBER() OVER(PARTITION BY comp.KeyComparisonID ORDER BY comp.KeyComparisonID) AS rn
		,ROW_NUMBER() OVER(PARTITION BY comp.KeyComparisonID 
			ORDER BY comp.KeyComparisonID,
			CASE 
				WHEN col.KeyColumnSchemaName = 'Staging' THEN 1 
				WHEN col.KeyColumnDatabaseName = 'DSDW' THEN 2
				ELSE 3
			END) AS DataFlow
	FROM TestLog.dbo.KeyComparison comp
	JOIN TestLog.dbo.KeyColumn col
	ON col.KeyComparisonID = comp.KeyComparisonID
)
SELECT 
	mid.ComparisonDate
	,mid.SUserLogin
	,mid.KeyComparisonID
	,lhs.TableName AS A_TableName
	,lhs.KeyColumnName AS A_KeyColumnName
	,lhs.DuplicateCount AS A_DuplicateCount
	,lhs.SetDifferenceCount AS A_SetDifferenceCount
	,mid.IntersectionCount
	,rhs.SetDifferenceCount AS B_SetDifferenceCount
	,rhs.DuplicateCount AS B_DuplicateCount
	,rhs.KeyColumnName AS B_KeyColumnName
	,rhs.TableName AS B_TableName
FROM mid 
JOIN lhs
ON mid.KeyComparisonID = lhs.KeyComparisonID 
JOIN rhs
ON lhs.KeyComparisonID = rhs.KeyComparisonID
AND lhs.DataFlow = 1
AND rhs.DataFlow = 2
GO

SELECT *
FROM vwKeyColumnCompare;

