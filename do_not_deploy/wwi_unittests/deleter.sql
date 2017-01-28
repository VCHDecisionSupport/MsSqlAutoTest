USE AutoTest
GO

--DELETE TOP 1 PERCENT Fact.[Order] ord 


-- SELECT *
-- FROM AutoTest.Map.PackageTable

DECLARE table_cur CURSOR LOCAL
FOR
SELECT 
	'WideWorldImportersDW' AS DatabaseName
	,sch.name
	,tab.name
FROM WideWorldImportersDW.sys.schemas AS sch
JOIN WideWorldImportersDW.sys.tables AS tab
ON tab.schema_id = sch.schema_id
WHERE 1=1
AND sch.name = 'Fact'

DECLARE @database_name varchar(500)
	,@schema_name varchar(500)
	,@table_name varchar(500)

OPEN table_cur;

FETCH NEXT FROM table_cur INTO 
	@database_name
	,@schema_name
	,@table_name

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT(@table_name)

	DECLARE @sql varchar(max);
	DECLARE @schema_table varchar(500) =QUOTENAME(@database_name)+'.'+ QUOTENAME(@schema_name)+'.'+QUOTENAME(@table_name);

	SET @sql = 'DELETE TOP (1) PERCENT FROM '+@schema_table


	PRINT(@sql)
	--EXEC(@sql)
	

	FETCH NEXT FROM table_cur INTO 
		@database_name
		,@schema_name
		,@table_name


END

CLOSE table_cur;
DEALLOCATE table_cur;

