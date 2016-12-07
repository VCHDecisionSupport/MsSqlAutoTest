--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspCreateColumnHistogram';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCreateColumnHistogram
	@pColumnProfileID int,
	@pTargetDatabaseName nvarchar(200) = 'TestLog',
	@pTargetSchemaName nvarchar(200) = 'SnapShot',
	@pTargetTableName nvarchar(200),
	@pTargetColumnName nvarchar(200)
AS
BEGIN
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	DECLARE @full_table_name varchar(200) = FORMATMESSAGE('%s.%s.%s',@pTargetDatabaseName,@pTargetSchemaName, @pTargetTableName)

	SET @sql = FORMATMESSAGE('@pColumnProfileID=%i  @pTargetTableName=%s  @pTargetColumnName=%s',@pColumnProfileID, @pTargetTableName, @pTargetColumnName)
	RAISERROR(@sql,0,1) WITH NOWAIT;

	SET @sql = FORMATMESSAGE('
	DECLARE valueCursor CURSOR
	FOR
	SELECT rn, ColumnValue
	FROM (
	SELECT COUNT(*) AS rn, ISNULL(CAST(%s AS varchar), ''NULL'') AS ColumnValue
	FROM %s
	GROUP BY %s) sub
	ORDER BY sub.rn DESC;', @pTargetColumnName, @full_table_name, @pTargetColumnName)
	--RAISERROR(@sql,0,1) WITH NOWAIT;
	EXEC(@sql);

	OPEN valueCursor;
	RAISERROR('FETCH NEXT',0,1) WITH NOWAIT;
	
	DECLARE @columnValue nvarchar(200);
	DECLARE @valueCount int;

	FETCH NEXT FROM valueCursor INTO @valueCount, @columnValue;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = FORMATMESSAGE('INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount) VALUES (%i, ''%s'', %i)',@pColumnProfileID, @columnValue, @valueCount)
		RAISERROR(@sql, 0, 1) WITH NOWAIT;
		EXEC(@sql);
		FETCH NEXT FROM valueCursor INTO @valueCount, @columnValue;
	END

	CLOSE valueCursor;
	DEALLOCATE valueCursor;
	--SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL;', @full_table_name, @column_name); 
	--SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
	--EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;
	--RAISERROR('@null_count: %i',0,1,@null_count);

END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspCreateColumnHistogram @pColumnProfileID=6,  @pTargetTableName='PreDR123AssessmentContactFactPkgExecKey312705',  @pTargetColumnName='UDFTable'
INSERT INTO TestLog.dbo.ColumnHistogram (ColumnProfileID, ColumnValue, ValueCount) VALUES (6, 'assu_icm1', 287706)