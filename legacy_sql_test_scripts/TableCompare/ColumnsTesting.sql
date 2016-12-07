
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;

	DECLARE @L_comp_col varchar(500);
	DECLARE @R_comp_col varchar(500);

	--** 1st Primary Key for Staging--------------------------------------------------------
	DECLARE @primary_key_L varchar(100) = 'DSDW.Staging.CommunityPersonName.ETLAuditID'; 
	--** 1st Primary Key for Fact-----------------------------------------------------------
	DECLARE @primary_key_R varchar(100) = 'DSDW.Community.PersonNameFact.ETLAuditID'; 
	----------------------------------------------------------------------------------------
	DECLARE @L_p_key varchar(50) = PARSENAME(@primary_key_L,1)
	DECLARE @L_tab varchar(50) = left(@primary_key_L, charindex('.' +@L_p_key, @primary_key_L) - 1) 

	DECLARE @R_p_key varchar(50) = PARSENAME(@primary_key_R,1)
	DECLARE @R_tab varchar(50) = left(@primary_key_R, charindex('.' +@R_p_key, @primary_key_R) - 1) 

	DECLARE @dyn_sql nvarchar(4000);
	DECLARE @Cursor as CURSOR;
	DECLARE @count int = 1;

	CREATE TABLE #comp_cols_tab (
		tabL varchar(100),
		tabR varchar(100) 
	);

	SET NUMERIC_ROUNDABORT OFF
	SET ANSI_PADDING, ANSI_WARNINGS ON
	
	CREATE TABLE #output_table (
		[Column Name] varchar(50),
		[Stg PKey,] varchar(50),
		[Distct Stg PKey,] varchar(50),
		[Stg NotNull Cnt,] varchar(50),
		[Stg=Fact on PK,] varchar(50),
		[Stg=Fact on Col,] varchar(50),
		[Fact NotNull Cnt,] varchar(50),
		[Fact PKey,] varchar(50),
		[Distct Fact PKey] varchar(50)
	);


	INSERT INTO #comp_cols_tab (tabL, tabR)
	SELECT tableL=replace(colL, ' ', ''), tableR=replace(colR,' ','')
	FROM
	(
     SELECT
           row_number() OVER (ORDER BY (SELECT 100)) as row_numL, t.c.value('.', 'VARCHAR(2000)') as colL
     FROM (
          SELECT txml = cast('<r>'+replace(replace(replace(replace(
		  --** Columns for Staging----------------------------------------------------------------
		  'StartDateINT,
		  EndDateINT

			'  
		  ----------------------------------------------------------------------------------------
		  ,'&','&amp;'), ',', '</r><r>'), char(13)+char(10),''), char(9), '')+'</r>' as xml)         
     ) r
     OUTER APPLY txml.nodes('/r') t(c)
     where t.c.value('.', 'VARCHAR(2000)') != ''
	) t1
	INNER JOIN
	(
     SELECT row_number() OVER (ORDER BY (SELECT 100)) as row_numR, p.c.value('.', 'VARCHAR(2000)') as colR
     FROM (
          SELECT txml = cast('<r>'+replace(replace(replace(replace(
		  --** Columns for FactTable--------------------------------------------------------------
		  'StartDateID,
		  EndDateID


			'  
		  ----------------------------------------------------------------------------------------
		  ,'&','&amp;'), ',', '</r><r>'), char(13)+char(10),''), char(9), '')+'</r>' as xml)		  
     ) r
     OUTER APPLY txml.nodes('/r') p(c)
	 WHERE p.c.value('.', 'VARCHAR(2000)') != ''
	) t2
	ON row_numL = row_numR

	
	SET @Cursor = CURSOR FOR
	SELECT tabL, tabR FROM #comp_cols_tab;
	 
	OPEN @Cursor;
	FETCH NEXT FROM @Cursor INTO @L_comp_col, @R_comp_col;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SET @dyn_sql = N' 
	INSERT INTO #output_table 
	SELECT tabR, col1, col2, col7, col3, col4, col8, col5, col6
	FROM 
	(SELECT tabR, row_number() OVER (ORDER BY (SELECT 100)) as row_num from #comp_cols_tab) as t1
	JOIN 
	(SELECT
		COUNT(A.'+@L_p_key+') as col1
       ,COUNT(DISTINCT A.'+@L_p_key+') as col2
       ,COUNT(A.'+@L_p_key+' + B.'+@R_p_key+') as col3
       ,SUM(CASE WHEN A.'+@L_p_key+' = B.'+@R_p_key+' AND ISNULL(B.'+@R_comp_col+' ,0) = ISNULL(A.'+@L_comp_col+',0) THEN 1 ELSE 0 END) as col4
       ,COUNT(B.'+@R_p_key+') as col5
       ,COUNT(DISTINCT B.'+@R_p_key+') as col6

	FROM '+@R_tab+' as B
	FULL OUTER JOIN '+@L_tab+' as A
	ON B.'+@R_p_key+' = A.'+@L_p_key+'
	--** If there is more than 1 primary key: Uncomment!----------------------------------
	--AND B.SourceCurrentLocationID = A.SourceCurrentLocationID 
	--------------------------------------------------------------------------------------
	) as t2
	ON t1.row_num ='+ cast(@count as nvarchar(100)) + '
	JOIN 
	(SELECT count(*) as col7
	 FROM '+@L_tab+'
	 WHERE '+@L_comp_col+' is not null OR '+@L_comp_col+' = 0 OR '+@L_comp_col+' <> ''''
	 )as t3
	ON t1.row_num ='+ cast(@count as nvarchar(100)) + '
	JOIN 
	(SELECT count(*) as col8
	 FROM '+@R_tab+'
	 WHERE '+@R_comp_col+' is not null OR '+@R_comp_col+' = 0 OR '+@R_comp_col+' <> ''''
	 )as t4
	ON t1.row_num ='+ cast(@count as nvarchar(100))  

	
	EXEC (@dyn_sql)
	
	FETCH NEXT FROM @Cursor INTO @L_comp_col, @R_comp_col;
	SET @count = @count +1;
	END
	
	--select *
	--from #comp_cols_tab

	select *
	from #output_table
		
	DROP TABLE #output_table
	DROP TABLE #comp_cols_tab

END
GO