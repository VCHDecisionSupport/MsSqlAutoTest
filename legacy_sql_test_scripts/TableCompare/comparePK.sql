	DECLARE @dyn_sql NVARCHAR(4000);
	DECLARE @ParamDefinition NVARCHAR(500);
	
	DECLARE @message NVARCHAR(MAX);
	DECLARE @log_results BIT = 1;

	DECLARE @pTA nvarchar(500) = 'A'
	DECLARE @pTB nvarchar(500) = 'B'

	DECLARE @pPkA nvarchar(500) = 'SourceSystemClientID,PatientID,SourceBirthDateID'
	DECLARE @pPkB nvarchar(500) = 'SourceSystemClientID,PatientID,SourceBirthDateID'

	SELECT * FROM dbo.[strSplit] (@pPkA, ', ')

	DECLARE @join nvarchar(max);

	SELECT @join=' AND'+SUBSTRING((
	SELECT 
		' AND '+@pTA+'.'+colA+' = '+@pTB+'.'+colB AS [text()]
	FROM (
		SELECT ISNULL(PkA.Item,PkB.Item) AS colA, ISNULL(PkB.Item,PkA.Item) AS colB 
		FROM dbo.[strSplit] ('SourceSystemClientID,PatientID', ',') AS PkA
		FULL JOIN dbo.[strSplit] (@pPkB, ',') AS PkB
		ON ISNULL(PkA.RowID,PkB.RowID) = ISNULL(PkB.RowID,PkA.RowID)
		) pk_pairs
	FOR XML PATH('')),5,5000)


	PRINT @join;

--#region compare given keys

	/* 
		START PRIMARY KEY COMPARISON 
	*/
	DECLARE @TableARowCount INT;
	DECLARE @TableADistinctCount INT;
	DECLARE @TableANullCount INT;
	DECLARE @TableBRowCount INT;
	DECLARE @TableBDistinctCount INT;
	DECLARE @TableBNullCount INT;
	DECLARE @KeyMatchCount INT;

	SET @ParamDefinition = N'
		@KeyMatchCountOUT INT OUTPUT';

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@KeyMatchCountOUT = ISNULL(COUNT(*),0)
	FROM ' + @pTB + ' AS B
	INNER JOIN ' + @pTA + ' AS A
	ON 1=1
	'+@join

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END
	PRINT 'KeyMatchCount'

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@KeyMatchCountOUT = @KeyMatchCount OUTPUT
	PRINT @KeyMatchCount


	SET @ParamDefinition = N'
		@TableARowCountOUT INT OUTPUT
		,@TableADistinctCountOUT INT OUTPUT
		,@TableANullCountOUT INT OUTPUT'

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@TableARowCountOUT = ISNULL(COUNT(*),0)
		,@TableADistinctCountOUT = ISNULL(COUNT(DISTINCT A.' + @A_key_col + '),0)
		,@TableANullCountOUT = ISNULL(SUM(CASE WHEN A.' + @A_key_col + ' IS NULL THEN 1 ELSE 0 END), 0)
	FROM ' + @A_db + '.' + @A_schema + '.' + @A_tab + ' AS A'

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@TableARowCountOUT = @TableARowCount OUTPUT
		,@TableADistinctCountOUT = @TableADistinctCount OUTPUT
		,@TableANullCountOUT = @TableANullCount OUTPUT
	PRINT @TableARowCount 
	PRINT @TableADistinctCount
	PRINT @TableANullCount


	SET @ParamDefinition = N'
		@TableBRowCountOUT INT OUTPUT
		,@TableBDistinctCountOUT INT OUTPUT
		,@TableBNullCountOUT INT OUTPUT'

	SET @dyn_sql = N'
	-- SQL to set variables
	SELECT 
		@TableBRowCountOUT = ISNULL(COUNT(*),0)
		,@TableBDistinctCountOUT = ISNULL(COUNT(DISTINCT B.' + @B_key_col + '),0)
		,@TableBNullCountOUT = ISNULL(SUM(CASE WHEN B.' + @B_key_col + ' IS NULL THEN 1 ELSE 0 END), 0)
	FROM ' + @B_db + '.' + @B_schema + '.' + @B_tab + ' AS B'

	IF @debug > 1
	BEGIN
		PRINT ''
		PRINT @dyn_sql
	END

	EXEC sp_executesql @dyn_sql
		,@ParamDefinition
		,@TableBRowCountOUT = @TableBRowCount OUTPUT
		,@TableBDistinctCountOUT = @TableBDistinctCount OUTPUT
		,@TableBNullCountOUT = @TableBNullCount OUTPUT
	PRINT @TableBRowCount 
	PRINT @TableBDistinctCount
	PRINT @TableBNullCount
	/* 
		END PRIMARY KEY COMPARISON 
	*/
--#endregion compare given keys