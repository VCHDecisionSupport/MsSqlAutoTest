USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateProfile';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateProfile
	@pTestConfigLogID int,
	@pTargetDatabaseName nvarchar(200) = 'AutoTest',
	@pTargetSchemaName nvarchar(200) = 'SnapShot',
	@pTargetTableName nvarchar(200),
	@pTableProfileTypeID int,
	@pColumnProfileTypeID int,
	@pColumnHistogramTypeID int,
	@pSubQueryFilter nvarchar(max) = null
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	RAISERROR('      uspCreateProfile: %s (@pTableProfileTypeID: %i)', 0, 1, @pTargetTableName, @pTableProfileTypeID) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	-- objectID
	DECLARE @objectID int;
	SELECT @objectID=objectID FROM TestConfigLog WHERE TestConfigLogID = @pTestConfigLogID

	SELECT @pSubQueryFilter = ISNULL(@pSubQueryFilter, '')

	DECLARE @full_table_name varchar(200) = FORMATMESSAGE('%s.%s.%s',@pTargetDatabaseName,@pTargetSchemaName, @pTargetTableName)
	-- RAISERROR('full_table_name: %s',0,1,@full_table_name) WITH NOWAIT;

	DECLARE @table_row_count int;
	SET @sql = FORMATMESSAGE(N'SELECT @table_row_countOUT = COUNT(*) FROM %s AS tab WHERE 1=1 %s', @full_table_name, @pSubQueryFilter);
	SET @param = '@table_row_countOUT int OUT';
	--RAISERROR(@sql, 0, 1) WITH NOWAIT;

	EXEC sp_executesql @sql, @param, @table_row_countOUT = @table_row_count OUT;
	RAISERROR('record count: %i', 0, 1, @table_row_count);
	SET @sql = FORMATMESSAGE(N'INSERT INTO AutoTest.dbo.TableProfile (TestConfigLogID, RecordCount, TableProfileDate, TableProfileTypeID) VALUES(%i, %i, GETDATE(), %i)',@pTestConfigLogID, @table_row_count, @pTableProfileTypeID);
	--RAISERROR(@sql, 0, 1) WITH NOWAIT;

	EXEC(@sql);
	DECLARE @tableProfileID int;
	SET @tableProfileID = @@IDENTITY;
	-- RAISERROR('tableProfileID: %i', 0, 1, @tableProfileID) WITH NOWAIT;









	DECLARE @pAggFmt nvarchar(max) = ', COUNT(DISTINCT %s) AS %s'
	DECLARE @AggCols nvarchar(max);
	DECLARE @cols nvarchar(max);
	EXEC dbo.uspGetColumnNames 
	@pDatabaseName='AutoTest'
	,@pSchemaName='dbo'
	,@pObjectName=@pTargetTableName
	,@pFmt=@pAggFmt
	,@pColStr=@AggCols OUTPUT
	,@pSkipPkHash = 1

	EXEC dbo.uspGetColumnNames 
	@pDatabaseName='AutoTest'
	,@pSchemaName='dbo'
	,@pObjectName=@pTargetTableName
	,@pColStr=@cols OUTPUT
	,@pSkipPkHash = 1


	SET @sql = FORMATMESSAGE('
	INSERT INTO AutoTest.dbo.ColumnProfile (ColumnID, ColumnCount, TableProfileID, ColumnProfileTypeID)
	SELECT attr.Sequence AS ColumnID, pvt.ColumnCount, %i AS TableProfileID, %i AS ColumnProfileTypeID
	FROM (
	SELECT %i AS ObjectID, %s FROM %s
	) AS sub
	UNPIVOT 
	(
		ColumnCount FOR ColumnName IN (%s)
	) AS pvt
	JOIN DQMF.dbo.MD_ObjectAttribute AS attr
	ON attr.AttributePhysicalName = pvt.ColumnName
	AND attr.ObjectID = pvt.ObjectID
	',@TableProfileID, @pColumnProfileTypeID, @objectID, @AggCols, @full_table_name, @cols)

	--Raiserror(@sql, 0,0) WITH NOWAIT;
	--EXEC(@sql)

	DECLARE columnCursor CURSOR
	FOR
	SELECT 
		attr.AttributePhysicalName AS ColumnName
		,attr.Sequence AS ColumnID
	FROM DQMF.dbo.MD_ObjectAttribute AS attr
	WHERE ObjectID = @objectID
	AND ISActive = 1

	OPEN columnCursor;

	DECLARE @column_name nvarchar(100)
		,@columnId int
		,@full_column_name nvarchar(300)
		,@column_type sysname
		,@null_count int
		,@distinct_count int
		,@zero_count int
		,@blank_count int

	FETCH NEXT FROM columnCursor INTO @column_name, @columnID;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- RAISERROR('@full_table_name: %s',0,1,@full_table_name);
		-- RAISERROR('@column_name: %s',0,1,@column_name);
		-- SET @full_column_name = @full_table_name+'.'+@column_name
		-- -- RAISERROR('@full_column_name: %s',0,1,@full_column_name);
		
		-- SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL %s;', @full_table_name, @column_name, @pSubQueryFilter); 
		-- SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
		-- EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;
		-- -- RAISERROR('@null_count: %i',0,1,@null_count);

		 SET @sql = FORMATMESSAGE(N'SELECT @distinct_countOUT = COUNT(DISTINCT %s) FROM %s WHERE 1=1 %s', @column_name, @full_table_name, @pSubQueryFilter); 
		 SET @param = FORMATMESSAGE(N'@distinct_countOUT int OUT');
		 EXEC sp_executesql @sql, @param, @distinct_countOUT = @distinct_count OUT;
		 -- RAISERROR('@distinct_count: %i',0,1,@distinct_count);

		-- SET @sql = FORMATMESSAGE(N'SELECT @zero_countOUT = COUNT(*) FROM %s WHERE CAST(%s AS varchar(100))= ''0'' %s;', @full_table_name, @column_name, @pSubQueryFilter); 
		-- SET @param = FORMATMESSAGE(N'@zero_countOUT int OUT');
		-- EXEC sp_executesql @sql, @param, @zero_countOUT = @zero_count OUT;
		-- -- RAISERROR('@zero_count: %i',0,1,@zero_count);

		-- SET @sql = FORMATMESSAGE(N'SELECT @blank_countOUT = COUNT(*) FROM %s WHERE %s= '''' %s;', @full_table_name, @column_name, @pSubQueryFilter); 
		-- SET @param = FORMATMESSAGE(N'@blank_countOUT int OUT');
		-- EXEC sp_executesql @sql, @param, @blank_countOUT = @blank_count OUT;
		-- -- RAISERROR('@blank_count: %i',0,1,@blank_count);
		
		SET @sql = FORMATMESSAGE('INSERT INTO AutoTest.dbo.ColumnProfile (ColumnID, ColumnCount, TableProfileID, ColumnProfileTypeID) VALUES (%i, %i, %i, %i);',@columnId, @distinct_count, @tableProfileID, @pColumnProfileTypeID);
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);

		DECLARE @columnProfileID int;
		SET @columnProfileID = @@IDENTITY;
		-- RAISERROR('@columnProfileID = %i', 0, 1, @columnProfileID) WITH NOWAIT;
		
		SELECT @pColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'SimpleColumnHistogram'
		IF @distinct_count < 1000 
		BEGIN
			-- RAISERROR('creating ColumnHistogram',0,1) WITH NOWAIT;
			EXEC dbo.uspInsColumnHistogram 
				@pColumnProfileID = @columnProfileID,
				@pTargetDatabaseName = @pTargetDatabaseName,
				@pTargetSchemaName = @pTargetSchemaName,
				@pTargetTableName = @pTargetTableName,
				@pTargetColumnName = @column_name,
				@pSubQueryFilter = @pSubQueryFilter,
				@pColumnHistogramTypeID = @pColumnHistogramTypeID
			-- RAISERROR('ColumnHistogram complete',0,1) WITH NOWAIT;

		END


		FETCH NEXT FROM columnCursor INTO @column_name, @columnID;
		

	END


	CLOSE columnCursor;
	DEALLOCATE columnCursor;

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('      !uspCreateProfile: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--DECLARE @PreEtlKeyMisMatchTableProfileTypeID int;
--DECLARE @PreEtlKeyMisMatchColumnProfileTypeID int;
--DECLARE @PreEtlKeyMisMatchColumnHistogramTypeID int;
--SELECT @PreEtlKeyMisMatchTableProfileTypeID = TableProfileTypeID FROM AutoTest.dbo.TableProfileType WHERE TableProfileTypeDesc = 'PreEtlKeyMisMatchTableProfile'
--SELECT @PreEtlKeyMisMatchColumnProfileTypeID = ColumnProfileTypeID FROM AutoTest.dbo.ColumnProfileType WHERE ColumnProfileTypeDesc = 'PreEtlKeyMisMatchColumnProfile'
--SELECT @PreEtlKeyMisMatchColumnHistogramTypeID = ColumnHistogramTypeID FROM AutoTest.dbo.ColumnHistogramType WHERE ColumnHistogramTypeDesc = 'PreEtlKeyMisMatchColumnHistogram'

--DECLARE @PreEtlKeyMisMatchName varchar(100);
--DECLARE @pTestConfigLogID int;

--EXEC AutoTest.dbo.uspCreateProfile @pTestConfigLogID = @pTestConfigLogID, @pTargetTableName = @PreEtlKeyMisMatchName, @pTableProfileTypeID = @PreEtlKeyMisMatchTableProfileTypeID, @pColumnProfileTypeID = @PreEtlKeyMisMatchColumnProfileTypeID, @pColumnHistogramTypeID = @PreEtlKeyMisMatchColumnHistogramTypeID;