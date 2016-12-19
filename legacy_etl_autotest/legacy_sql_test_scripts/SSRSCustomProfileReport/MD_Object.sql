DECLARE 
	@DatabaseName varchar(100) = 'CommunityMart',
	@ObjectName varchar(100) = '[dbo].[ScreeningResultFact]',
	@ColumnName varchar(100) = '',
	@ColumnValue varchar(100) = null

--DECLARE @ObjectName varchar(100) = '[Dim].[Gender]'
--DECLARE @DatabaseName varchar(100) = 'CommunityMart'

BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	DECLARE @fmt nvarchar(500);

	-- break up user input into parts, fill in missing parts with defaults
	DECLARE @schema_name sysname;
	DECLARE @table_name sysname;
	SET @schema_name = PARSENAME(@ObjectName, 2)
	SET @table_name = PARSENAME(@ObjectName, 1)

	DECLARE @sql nvarchar(max);

	DECLARE @table_row_count int;
	DECLARE @param nvarchar(500);
	DECLARE @filter_clause nvarchar(500);

	SELECT ObjectPKField
		--,quotename(ObjectPhysicalName)+'.'+quotename(ObjectSchemaName),@ObjectName
	FROM DQMF.dbo.MD_Object
	WHERE quotename(ObjectSchemaName)+'.'+ quotename(ObjectPhysicalName)= @ObjectName
END