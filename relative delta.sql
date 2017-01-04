USE AutoTest
GO

WITH lag AS (
SELECT *
	,LAG(RecordCount) OVER(PARTITION BY DatabaseName, SchemaName, TableName ORDER BY ProfileID ASC) AS PrevRecordCount
FROM AutoTest.dbo.TableProfile AS tab_pro
)
SELECT 
	*
	,1.*(RecordCount-PrevRecordCount)/PrevRecordCount AS RelativeChange
FROM lag
WHERE lag.PrevRecordCount IS NOT NULL;