
DELETE AutoTest.Map.PackageTable;

INSERT INTO AutoTest.Map.PackageTable
(
	PackageName
	,DatabaseName
	,SchemaName
	,TableName
)
SELECT 
	'pkg' AS PackageName
	,'WideWorldImportersDW' AS DatabaseName
	,sch.name
	,tab.name
FROM WideWorldImportersDW.sys.schemas AS sch
JOIN WideWorldImportersDW.sys.tables AS tab
ON tab.schema_id = sch.schema_id
WHERE 1=1
AND sch.name = 'Fact'


EXEC dbo.uspProfilePackageTables @pPkgExecKey = 123, @pPackageName = 'pkg'

SELECT * FROM dbo.TableProfile
SELECT * FROM dbo.ColumnProfile
SELECT * FROM dbo.ColumnHistogram




