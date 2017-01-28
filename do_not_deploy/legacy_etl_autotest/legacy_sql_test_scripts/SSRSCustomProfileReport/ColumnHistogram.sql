DECLARE @column_name nvarchar(100) = 'SCUDays'
DECLARE @ObjectName varchar(100) = '[ADR].[ScuFact]'
DECLARE @DatabaseName varchar(100) = 'DSDW'
DECLARE @distinct_count int = 86
DECLARE @row_count int = 702728

DECLARE @sql nvarchar(1000);

SET @sql = FORMATMESSAGE('
SELECT %s AS value, COUNT(*) AS frequency, 1.*COUNT(*)/%i AS relative_frequency
FROM %s.%s
GROUP BY %s
HAVING 100.*COUNT(*)/%i > 0.1
', @column_name, @row_count, @DatabaseName, @ObjectName, @column_name, @row_count)

--PRINT @sql;
EXEC(@sql);

	SELECT SCUDays AS value, COUNT(*) AS frequency, 100.*COUNT(*)/@row_count AS relative_frequency 
	FROM DSDW.[ADR].[ScuFact]
	GROUP BY SCUDays
	HAVING 100.*COUNT(*)/@row_count > 0.1

