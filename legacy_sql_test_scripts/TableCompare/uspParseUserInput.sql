USE CommunityMart
GO

IF OBJECT_ID('dbo.uspParseUserDataSet','P') IS NULL
BEGIN
	PRINT 'dbo.uspParseUserDataSet'
	EXEC('CREATE PROC dbo.uspParseUserDataSet AS')
END;
GO

ALTER PROC dbo.uspParseUserDataSet
	@p nvarchar(MAX)
	,@pPk nvarchar(1000)
	,@pTempName nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'dbo.uspParseUserDataSet'
	DECLARE @tempTableName varchar(255) = @pTempName;
	DECLARE @tempViewName varchar(255) = 'Temp_View_'+@pTempName;

	DECLARE @message varchar(200);
	DECLARE @sql varchar(MAX);
	DECLARE @param varchar(MAX);

	SET @message = FORMATMESSAGE('@p = %s',@p);
	PRINT @message;

	IF OBJECT_ID(@tempViewName,'V') IS NOT NULL
		EXEC('DROP VIEW '+@tempViewName);

	DECLARE @tab NVARCHAR(128) = PARSENAME(@p, 2);
	DECLARE @schema NVARCHAR(128) = PARSENAME(@p, 3);
	DECLARE @db NVARCHAR(128) = PARSENAME(@p, 4);
	/*
		handle multicolumn pk by HASHing the concatenation it's columns casted to varchar
	*/
	DECLARE @hash_pk nvarchar(900);
	SELECT @hash_pk=' HASHBYTES(''MD2'','+SUBSTRING((
	SELECT 
		'+''_''+ CAST('+col+' AS varchar(128)) ' AS [text()]
	FROM (
		SELECT Pk.Item AS col
		FROM dbo.[strSplit] (@pPk, ',') AS Pk
		) pk_pairs
	FOR XML PATH('')),2,5000)+')'
	PRINT @hash_pk
	/*
		check if @p is a query
	*/
	IF PATINDEX('%SELECT%[a-zA-z]%FROM%[a-zA-z]%',@p) != 0
	BEGIN
		PRINT '
		------------------------
		query detected: creating view of query
		------------------------
		'
		SET @sql = 'CREATE VIEW '+@tempViewName+' AS SELECT '+@hash_pk+' AS __PK__,sub.* FROM (' + @p+') AS sub';
		PRINT @sql
		EXEC(@sql)
	END


	ELSE IF @tab IS NOT NULL OR @schema IS NOT NULL OR @db IS NOT NULL
	BEGIN
		PRINT '
		------------------------
		fully qualified table detected: creating view of table
		------------------------
		'
		SET @sql = 'CREATE VIEW '+@tempViewName+' AS SELECT '+@hash_pk+' AS __PK__,sub.* FROM (SELECT * FROM ' + @p + ')';
		PRINT @sql
		EXEC(@sql)
	END

	SET @sql = 'SELECT * FROM '+@tempViewName
	PRINT @sql;
	EXEC(@sql);


	---- get columns of query
	--SELECT col.name
	--FROM sys.views AS vw
	--JOIN sys.columns AS col
	--ON vw.object_id = col.object_id
	--WHERE vw.name = @tempViewName
		
	--IF OBJECT_ID(@tempTableName,'U') IS NOT NULL
	--EXEC('DROP TABLE '+@tempTableName);
		
	--SET @sql = 'SELECT * INTO '+@tempTableName+' FROM '+@tempViewName
	--PRINT @sql;
	--EXEC(@sql);



	--SET @sql = 'CREATE CLUSTERED INDEX IX_'+@tempTableName+' ON '+@tempTableName+'(__PK__);';
	--EXEC(@sql);

	--SET @sql = 'SELECT * FROM '+@tempTableName
	--PRINT @sql;
	--EXEC(@sql);

END;
GO

DECLARE @pQueryA varchar(MAX) = 'SELECT SourceSystemClientID FROM DSDW.Community.PersonFact'
	,@pQueryB varchar(MAX) = 'SELECT per_fact.* FROM CommunityMart.dbo.PersonFact AS per_fact'
	,@pPk varchar(MAX) = 'SourceSystemClientID'
DECLARE @pPkA nvarchar(500) = 'SourceSystemClientID,PatientID,SourceBirthDateID'
DECLARE @pPkB nvarchar(500) = 'SourceSystemClientID,PatientID,SourceBirthDateID'
DECLARE @pTA nvarchar(500) = 'A'
DECLARE @pTB nvarchar(500) = 'B'
--EXEC dbo.uspParseUserDataSet @pQueryA, @pPkA, @pTA;
EXEC dbo.uspParseUserDataSet @pQueryB, @pPkB, @pTB;
--EXEC dbo.uspParseUserDataSet @pQueryB, @pTB;

--SET @pPkA  = 'SourceSystemClientID,PatientID,SourceBirthDateID'


--SELECT * FROM dbo.[strSplit] (@pPkA, ', ')

--DECLARE @join nvarchar(max);
--SELECT @join=' AND'+SUBSTRING((
--SELECT 
--	' AND '+@pTA+'.'+colA+' = '+@pTB+'.'+colB AS [text()]
--FROM (
--	SELECT ISNULL(PkA.Item,PkB.Item) AS colA, ISNULL(PkB.Item,PkA.Item) AS colB 
--	FROM dbo.[strSplit] ('SourceSystemClientID,PatientID', ',') AS PkA
--	FULL JOIN dbo.[strSplit] (@pPkB, ',') AS PkB
--	ON ISNULL(PkA.RowID,PkB.RowID) = ISNULL(PkB.RowID,PkA.RowID)
--	) pk_pairs
--FOR XML PATH('')),5,5000)
--PRINT @join;




--DECLARE @hash_pk nvarchar(max);
--SELECT @hash_pk=' HASH(''MD2'','+SUBSTRING((
--SELECT 
--	'+''_''+ CAST('+colA+' AS varchar(128)) ' AS [text()]
--FROM (
--	SELECT PkA.Item AS colA
--	FROM dbo.[strSplit] ('SourceSystemClientID,PatientID', ',') AS PkA
--	) pk_pairs
--FOR XML PATH('')),2,5000)
--PRINT @hash_pk