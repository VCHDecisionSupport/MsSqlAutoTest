USE gcTest
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.uspProfileTable') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	EXEC ('CREATE PROCEDURE dbo.uspProfileTable AS');
END
GO

/****** Object:  StoredProcedure dbo.uspuspGetTables   DR0000 Graham Crowell 2016-01-00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.uspProfileTable
	@pDatabaseName varchar(500)
	,@pTableName varchar(500) = NULL
	,@pDistinctCountLimit int = 10000
AS
BEGIN
	PRINT('dbo.uspProfileTable(@pDatabaseName='+@pDatabaseName+', @pTableName='+@pTableName+')');

	CREATE TABLE #temp_columns (
		schema_name varchar(500)
		,table_name varchar(500)
		,column_name varchar(500)
	);

	INSERT INTO #temp_columns
	EXEC dbo.uspGetColumns @pDatabaseName=@pDatabaseName, @pTableName=@pTableName

	DECLARE @schema_name varchar(500)
		,@table_name varchar(500)
		,@column_name varchar(500)
		,@sql nvarchar(max)
		,@param nvarchar(max)
		,@distinct_count int;

	DECLARE cur CURSOR
	FOR
	SELECT *
	FROM #temp_columns;

	OPEN cur;

	FETCH NEXT FROM cur INTO 
		@schema_name
		,@table_name
		,@column_name;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@schema_name);
		PRINT(@table_name);
		PRINT(@column_name);
	SET @sql = '
SELECT @distinct_countOUT=COUNT(DISTINCT '+@column_name+')
FROM '+@pDatabaseName+'.'+@schema_name+'.'+@table_name+'
';
	PRINT(@sql);
	SET @param = '@distinct_countOUT int OUTPUT';
	EXECUTE sp_executesql @sql, @param, @distinct_countOUT=@distinct_count OUTPUT;

	PRINT('COUNT(DISTINCT '+@column_name+') = '+CAST(@distinct_count AS varchar));

	IF @distinct_count > @pDistinctCountLimit
	BEGIN
		PRINT('too many distinct values (@pDistinctCountLimit='+CAST(@pDistinctCountLimit AS varchar)+')... skipping histogram for '+@column_name);
	END
	ELSE
	BEGIN
	SET @sql = '
INSERT INTO gcTest.dbo.ColumnHistogram
SELECT 
	GETDATE() AS ColumnHistogramDate
	,'''+@pDatabaseName+''' AS DatabaseName
	,'''+@table_name+''' AS TableName
	,'''+@column_name+''' AS ColumnName
	,'+@column_name+' AS ColumnValue
	,COUNT(*) AS ValueCount
FROM '+@pDatabaseName+'.'+@schema_name+'.'+@table_name+'
GROUP BY '+@column_name+';';
		PRINT(@sql);
		EXEC(@sql);
		END
		FETCH NEXT FROM cur INTO 
			@schema_name
			,@table_name
			,@column_name;
	END

	CLOSE cur;
	DEALLOCATE cur;

END
GO

--DELETE gcTest.dbo.ColumnHistogram;
EXEC dbo.uspProfileTable @pDatabaseName='CommunityMart', @pTableName='ReferralFact';

SELECT *
FROM gcTest.dbo.ColumnHistogram;