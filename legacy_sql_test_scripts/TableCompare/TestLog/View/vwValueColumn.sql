USE TestLog
GO

IF OBJECT_ID('dbo.vwValueColumnCompare','V') IS NOT NULL
	DROP VIEW dbo.vwValueColumnCompare;
GO
CREATE VIEW dbo.vwValueColumnCompare
AS
WITH 
	key_comp AS (
	SELECT key_comp.ComparisonDate
		,key_comp.KeyComparisonID
		,key_comp.SUserLogin

	FROM TestLog.dbo.KeyComparison AS key_comp
),
	val_comp AS (
	SELECT 
		val_comp.IntersectionCount
		,val_comp.ValueComparisonID
		,val_comp.KeyComparisonID

	FROM TestLog.dbo.ValueComparison AS val_comp
),
lhs AS (
	SELECT 
		key_col.KeyComparisonID

		,key_col.KeyColumnDatabaseName + 
		'.'+key_col.KeyColumnSchemaName +
		'.'+key_col.KeyColumnTableName AS TableName
		,key_col.KeyColumnName
		,key_col.KeyColumnID

		,val_comp.ValueComparisonID

		,val_col.ValueColumnID
		,val_col.ColumnName

		,val_col.KeyMatchedDistinctCount
		,val_col.KeyMatchedNullCount
		,val_col.FullNullCount
		,val_col.FullDistinctCount
		,val_col.SetDifferenceCount

		,ROW_NUMBER() OVER(PARTITION BY val_comp.ValueComparisonID 
			ORDER BY val_comp.ValueComparisonID,
			val_col.ValueColumnID,
			CASE 
				WHEN key_col.KeyColumnSchemaName = 'Staging' THEN 1 
				WHEN key_col.KeyColumnDatabaseName = 'DSDW' THEN 2
				ELSE 3
			END) AS DataFlow
	FROM TestLog.dbo.KeyComparison AS key_comp
	JOIN TestLog.dbo.KeyColumn AS key_col
	ON key_col.KeyComparisonID = key_comp.KeyComparisonID
	JOIN TestLog.dbo.ValueComparison AS val_comp
	ON key_comp.KeyComparisonID = val_comp.KeyComparisonID
	JOIN TestLog.dbo.ValueColumn AS val_col
	ON val_comp.ValueComparisonID = val_col.ValueComparisonID
), rhs AS (
	SELECT 
		key_col.KeyComparisonID

		,key_col.KeyColumnDatabaseName + 
		'.'+key_col.KeyColumnSchemaName +
		'.'+key_col.KeyColumnTableName AS TableName
		,key_col.KeyColumnName
		,key_col.KeyColumnID

		,val_comp.ValueComparisonID

		,val_col.ValueColumnID
		,val_col.ColumnName

		,val_col.KeyMatchedDistinctCount
		,val_col.KeyMatchedNullCount
		,val_col.FullNullCount
		,val_col.FullDistinctCount
		,val_col.SetDifferenceCount

		,ROW_NUMBER() OVER(PARTITION BY val_comp.ValueComparisonID 
			ORDER BY val_comp.ValueComparisonID,
			val_col.ValueColumnID,
			CASE 
				WHEN key_col.KeyColumnSchemaName = 'Staging' THEN 1 
				WHEN key_col.KeyColumnDatabaseName = 'DSDW' THEN 2
				ELSE 3
			END) AS DataFlow
	FROM TestLog.dbo.KeyComparison AS key_comp
	JOIN TestLog.dbo.KeyColumn AS key_col
	ON key_col.KeyComparisonID = key_comp.KeyComparisonID
	JOIN TestLog.dbo.ValueComparison AS val_comp
	ON key_col.KeyComparisonID = val_comp.KeyComparisonID
	JOIN TestLog.dbo.ValueColumn AS val_col
	ON val_comp.ValueComparisonID = val_col.ValueComparisonID
)
SELECT 
	key_comp.ComparisonDate
	,key_comp.SUserLogin
	,key_comp.KeyComparisonID
	--,lhs.ValueColumnID
	--,rhs.ValueColumnID

	,lhs.TableName AS A_TableName
	,lhs.KeyColumnName AS A_KeyColumnName
	,lhs.ColumnName AS A_ColumnName
	,lhs.KeyMatchedNullCount AS A_KeyMatchedNullCount
	,lhs.SetDifferenceCount AS A_SetDifferenceCount

	,val_comp.IntersectionCount

	,rhs.SetDifferenceCount AS B_SetDifferenceCount
	,rhs.KeyMatchedNullCount AS B_KeyMatchedNullCount
	,rhs.ColumnName AS B_ColumnName
	,rhs.KeyColumnName AS B_KeyColumnName
	,rhs.TableName AS B_TableName
FROM key_comp 
JOIN val_comp
ON key_comp.KeyComparisonID = val_comp.KeyComparisonID
JOIN lhs
ON val_comp.ValueComparisonID = lhs.ValueComparisonID 
JOIN rhs
ON lhs.ValueComparisonID = rhs.ValueComparisonID
AND lhs.DataFlow = 1
AND rhs.DataFlow = 2
GO

SELECT *
FROM dbo.vwValueColumnCompare;