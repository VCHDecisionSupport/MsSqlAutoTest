USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspInsColumnHistogram';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 1, 1) WITH NOWAIT;

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspInsColumnHistogram
	@pColumnProfileID int,
	@pTargetDatabaseName nvarchar(200) = 'AutoTest',
	@pTargetSchemaName nvarchar(200) = 'SnapShot',
	@pTargetTableName nvarchar(200),
	@pTargetColumnName nvarchar(200),
	@pSubQueryFilter nvarchar(max) = null,
	@pColumnHistogramTypeID int
AS
BEGIN
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	DECLARE @full_table_name varchar(200) = FORMATMESSAGE('%s.%s.%s',@pTargetDatabaseName,@pTargetSchemaName, @pTargetTableName)

	SET @sql = FORMATMESSAGE('        uspInsColumnHistogram: @pColumnProfileID=%i  @pTargetTableName=''%s''  @pTargetColumnName=''%s'' @pColumnHistogramTypeID=%i',@pColumnProfileID, @pTargetTableName, @pTargetColumnName, @pColumnHistogramTypeID)
	 RAISERROR(@sql,0,1) WITH NOWAIT;

	SELECT @pSubQueryFilter = ISNULL(@pSubQueryFilter, '')
	SET @sql = FORMATMESSAGE('
	DECLARE valueCursor CURSOR
	FOR
	SELECT rn, ColumnValue
	FROM (
	SELECT COUNT(*) AS rn, ISNULL(CAST([%s] AS varchar), ''NULL'') AS ColumnValue
	FROM %s
	WHERE 1=1 %s
	GROUP BY %s) sub
	ORDER BY sub.rn DESC;', @pTargetColumnName, @full_table_name,@pSubQueryFilter, @pTargetColumnName)
	--RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);

	OPEN valueCursor;
	-- RAISERROR('FETCH NEXT',0,1) WITH NOWAIT;
	
	DECLARE @columnValue nvarchar(200);
	DECLARE @valueCount int;

	FETCH NEXT FROM valueCursor INTO @valueCount, @columnValue;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = FORMATMESSAGE('INSERT INTO AutoTest.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount, ColumnHistogramTypeID) VALUES (%i, ''%s'', %i, %i)',@pColumnProfileID, REPLACE(CAST(@columnValue AS varchar(200)),'''',''''''), @valueCount, @pColumnHistogramTypeID)

		--RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);
		FETCH NEXT FROM valueCursor INTO @valueCount, @columnValue;
	END

	CLOSE valueCursor;
	DEALLOCATE valueCursor;
	--SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL;', @full_table_name, @column_name); 
	--SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
	--EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;
	--RAISERROR('@null_count: %i',0,1,@null_count);
	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('        !uspInsColumnHistogram: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END TRY
BEGIN CATCH
	DECLARE @ErrorNumber int;
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorProcedure int;
	DECLARE @ErrorLine int;
	DECLARE @ErrorMessage varchar(max);
	DECLARE @UserMessage nvarchar(max);

	SELECT 
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorProcedure = ERROR_PROCEDURE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE()

	SET @UserMessage = FORMATMESSAGE('AutoTest proc ERROR: %s 
		Error Message: %s
		Line Number: %i
		Severity: %i
		State: %i
		Error Number: %i
	',@ErrorProcedure, @ErrorMessage, @ErrorNumber, @ErrorLine, @ErrorSeverity, @ErrorState, @ErrorNumber);

	RAISERROR(@UserMessage,0,1) WITH NOWAIT, LOG
END CATCH;
END
GO
--EXEC dbo.uspInsColumnHistogram @pColumnProfileID=80,  @pTargetTableName='PreEtl_TestConfigID975',  @pTargetColumnName='ReferralReasonDesc', @pColumnHistogramTypeID=1
