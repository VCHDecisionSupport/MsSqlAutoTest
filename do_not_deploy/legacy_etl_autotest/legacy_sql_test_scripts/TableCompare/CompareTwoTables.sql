USE [DQMF]
GO

/****** Object:  StoredProcedure [dbo].[CompareTwoTables]    Script Date: 4/5/2016 2:26:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/* ============================================= 
 Author:			Adrian Procter 
 Create date:		31/03/2016 
 Description:		Compares 2 tables, reporting differences in structure or values
 NOTES:
       SourceTableFull = name of the table that contains the snapshot
                                    If no schema is specified, it defaults to 'DBO'
       NewTableFull  = name of the table that cointains the new data that we are checking the snapshot against
                                    If no schema is specified, it defaults to 'DBO'
       WhereClause          = When checking the data, this clause is applied to the data set, so it can be used to 
                                    check a resticted data set.  By default, it will compare all data
       CheckColumnName      = When specified, will restrict the data checking to just this one column
                                    By default will compare all fields
                                    The WhereClause and CheckColumnName can be used independently, or together.

 Change History: 
	<Date>                  <Alias>                <Desc> 

 =============================================*/ 

CREATE PROCEDURE [dbo].[CompareTwoTables] 
	@SourceTableFull VARCHAR(200),
	@NewTableFull VARCHAR(200),
	@WhereClause VARCHAR(MAX) = '',
	@CheckColumnName VARCHAR(100) = ''

AS   


SET NOCOUNT ON 


/*DECLARE @SourceTableFull VARCHAR(200)
DECLARE @NewTableFull VARCHAR(200)
DECLARE @WhereClause VARCHAR(MAX)
DECLARE @CheckColumnName VARCHAR(100)
*/



/* If no column name specified, fill in a token value to check for */
IF ISNULL(@CheckColumnName, '') = '' BEGIN SELECT @CheckColumnName = '/*ALL*/' END



/* Internal Declaration */
DECLARE @ResultsTableName VARCHAR(MAX)
DECLARE @ChangesTableName VARCHAR(MAX)
DECLARE @SQLSelect VARCHAR(MAX)
DECLARE @CreateTable VARCHAR(MAX)
DECLARE @CreateTableNew VARCHAR(MAX)
DECLARE @CreateTableSource VARCHAR(MAX)
DECLARE @SourceTable VARCHAR(200)
DECLARE @NewTable VARCHAR(200)
DECLARE @SourceTableSchema VARCHAR(200)
DECLARE @NewTableSchema VARCHAR(200)
DECLARE @ColumnName VARCHAR(200)
DECLARE @PrimaryKey VARCHAR(MAX)
DECLARE @PrimaryKeySource VARCHAR(MAX)
DECLARE @PrimaryKeyNew VARCHAR(MAX)
DECLARE @PrimaryKeyB VARCHAR(MAX)
DECLARE @WhereSQLClause VARCHAR(MAX)
DECLARE @WhereSQLClauseSource VARCHAR(MAX)
DECLARE @WhereSQLClauseNew VARCHAR(MAX)
DECLARE @DatabaseSource VARCHAR(100)
DECLARE @DatabaseNew VARCHAR(100)
DECLARE @ServerSource VARCHAR(100)
DECLARE @ServerNew VARCHAR(100)
DECLARE @NewTableStorage VARCHAR(MAX)


SELECT @ResultsTableName = '[ResultsTable'+replace(convert(char(36), NEWID()), '-', '')+']'
SELECT @ChangesTableName = '[ChangesTable'+replace(convert(char(36), NEWID()), '-', '')+']'

IF IsNull(@WhereClause, '') = '' BEGIN SELECT @WhereClause = ' WHERE ' END ELSE BEGIN SELECT @WhereClause = ' WHERE '+@WhereClause + ' AND ' END

/* Work backwards - from the final period this is always the table name */
/* Only if there is a '.' */
IF CHARINDEX('.', @NewTableFull) > 0 
BEGIN
	SELECT @NewTable=reverse(left(reverse(@NewTableFull), charindex('.', reverse(@NewTableFull))-1))
END
else begin SELECT @NewTable = @NewTableFull END
IF CHARINDEX('.', @SourceTableFull) > 0 
BEGIN
	SELECT @SourceTable=reverse(left(reverse(@SourceTableFull), charindex('.', reverse(@SourceTableFull))-1))
END
else begin SELECT @SourceTable = @SourceTableFull END


/* To get the schema, we look at the original string, subtracting off the table we already have */
/* Then, we are eith left with nothing, or the schema name followed by a final period */
/* We should be able to extract or extrapolate the schema name */
IF (LEN(@NewTableFull) - Len(@NewTable)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@NewTableFull,  LEN(@NewTableFull)-LEN(@NewTable))
	/* If this value is just 1 character long of a dot, then assume DBO
	   If this is 2 characters long, and is dot-dot then assume DBO */
	IF (@NewTableStorage='.' OR LEFT(reverse(@NewTableStorage),2)='..') 
		BEGIN SELECT @NewTableSchema = 'DBO' 	END
		ELSE
		BEGIN 
			SELECT @NewTableStorage = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
			IF CHARINDEX('.', @NewTableStorage) = 0 BEGIN SELECT @NewTableSchema = @NewTableStorage END ELSE
			BEGIN
				SELECT @NewTableSchema=reverse(left(reverse(@NewTableStorage), charindex('.', reverse(@NewTableStorage ), 1)-1))
			END
		END
END ELSE BEGIN SELECT @NewTableSchema = 'dbo' END


IF (LEN(@SourceTableFull) - Len(@SourceTable)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@SourceTableFull,  LEN(@SourceTableFull)-LEN(@SourceTable))
	/* If this value is just 1 character long of a dot, then assume DBO
	   If this is 2 characters long, and is dot-dot then assume DBO */
	IF (@NewTableStorage='.' OR LEFT(reverse(@NewTableStorage),2)='..') 
		BEGIN SELECT @SourceTableSchema = 'DBO' 	END
		ELSE
		BEGIN 
			SELECT @NewTableStorage = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
			IF CHARINDEX('.', @NewTableStorage) = 0 BEGIN SELECT @SourceTableSchema = @NewTableStorage END ELSE
			BEGIN
				SELECT @SourceTableSchema=reverse(left(reverse(@NewTableStorage), charindex('.', reverse(@NewTableStorage ), 1)-1))
			END
		END
END ELSE BEGIN SELECT @SourceTableSchema = 'dbo' END




/* Now we figure out if there a database name supplied */
IF (LEN(@NewTableFull) - Len(@NewTable) - 1 - Len(@NewTableSchema)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@NewTableFull,  LEN(@NewTableFull)-1-LEN(@NewTable)-LEN(@NewTableSchema))
	IF (@NewTableStorage='.' ) 
		BEGIN SELECT @DatabaseSource = '' END
		ELSE
		BEGIN 
			SELECT @NewTableStorage = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
			IF CHARINDEX('.', @NewTableStorage) = 0 BEGIN SELECT @DatabaseSource  = @NewTableStorage END ELSE
			BEGIN
				SELECT @DatabaseSource =reverse(left(reverse(@NewTableStorage), charindex('.', reverse(@NewTableStorage ), 1)-1))
			END
		END
END
ELSE BEGIN
SELECT @DatabaseSource = ''
END

IF (LEN(@SourceTableFull) - Len(@SourceTable) - 1 - Len(@SourceTableSchema)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@SourceTableFull,  LEN(@SourceTableFull)-1-LEN(@SourceTable)-LEN(@SourceTableSchema))
	IF (@NewTableStorage='.' ) 
		BEGIN SELECT @DatabaseSource = '' END
		ELSE
		BEGIN 
			SELECT @NewTableStorage = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
			IF CHARINDEX('.', @NewTableStorage) = 0 BEGIN SELECT @DatabaseSource  = @NewTableStorage END ELSE
			BEGIN
				SELECT @DatabaseSource =reverse(left(reverse(@NewTableStorage), charindex('.', reverse(@NewTableStorage ), 1)-1))
			END
		END
END
ELSE BEGIN
SELECT @DatabaseNew = ''
END


/* Now we figure out if there a server name supplied */
IF (LEN(@NewTableFull) - Len(@NewTable) - 1 - Len(@NewTableSchema) - 1 - LEN(@DatabaseSource)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@NewTableFull,  LEN(@NewTableFull)-1-LEN(@NewTable)-LEN(@NewTableSchema)-1-LEN(@DatabaseSource))
	IF (@NewTableStorage='.' ) 
		BEGIN SELECT @ServerSource = '' END
		ELSE
		BEGIN 
			/* What is left has to be the server name */
			SELECT @ServerSource = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
		END

END
ELSE BEGIN
SELECT @ServerSource = ''
END

IF (LEN(@SourceTableFull) - Len(@SourceTable) - 1 - Len(@SourceTableSchema) - 1 - LEN(@DatabaseSource)) > 0 
BEGIN
	SELECT @NewTableStorage = LEFT(@SourceTableFull,  LEN(@SourceTableFull)-1-LEN(@SourceTable)-LEN(@SourceTableSchema)-1-LEN(@DatabaseSource))
	IF (@NewTableStorage='.' ) 
		BEGIN SELECT @ServerSource = '' END
		ELSE
		BEGIN 
			/* What is left has to be the server name */
			SELECT @ServerSource = LEFT(@NewTableStorage, LEN(@NewTableStorage)-1) /* Strip off the final . */
		END

END
ELSE BEGIN
SELECT @ServerNew = ''
END



--SELECT @SourceTable = Right(@SourceTableFull, Len(@SourceTableFull) - CHARINDEX('.', @SourceTableFull))
--SELECT @NewTable = Right(@NewTableFull, Len(@NewTableFull) - CHARINDEX('.', @NewTableFull))


--/* Next is the schema.  If the schema is blank (ie not specified, or is a 0 length string because '' was used, assume DBO */
--SELECT @SourceTableSchema = SUBSTRING(@SourceTableFull, LEFT(@SourceTableFull, CHARINDEX('.', @SourceTableFull))
--IF LEN(@SourceTableSchema) > 0 BEGIN SELECT @SourceTableSchema = Left(@SourceTableSchema, Len(@SourceTableSchema) - 1) END ELSE BEGIN SELECT @SourceTableSchema = 'dbo' END
--SELECT @NewTableSchema = LEFT(@NewTableFull, CHARINDEX('.', @NewTableFull))
--IF LEN(@NewTableSchema) > 0 BEGIN SELECT @NewTableSchema = Left(@NewTableSchema, Len(@NewtableSchema) - 1) END ELSE BEGIN SELECT @NewTableSchema = 'dbo' END

--/* Get the schema */
--SELECT @SourceTableSchema = LEFT(@SourceTableFull, CHARINDEX('.', @SourceTableFull))
--IF LEN(@SourceTableSchema) > 0 BEGIN SELECT @SourceTableSchema = Left(@SourceTableSchema, Len(@SourceTableSchema) - 1) END ELSE BEGIN SELECT @SourceTableSchema = 'dbo' END
--SELECT @NewTableSchema = LEFT(@NewTableFull, CHARINDEX('.', @NewTableFull))
--IF LEN(@NewTableSchema) > 0 BEGIN SELECT @NewTableSchema = Left(@NewTableSchema, Len(@NewtableSchema) - 1) END ELSE BEGIN SELECT @NewTableSchema = 'dbo' END



/* 
       Step 1: the 2 tables should match the data types 
*/

/* Create a table to hold this information */
SELECT @CreateTable = 'CREATE TABLE [dbo].'+ @ChangesTableName + ' (ChangeType VARCHAR(100), SourceTableName VARCHAR(200), ColumnName VARCHAR(100), OldDataType VARCHAR(100), NewTableName VARCHAR(100), NewDataType VARCHAR(100) )'
EXEC (@CreateTable)


SELECT @SQLSelect = 'INSERT INTO '+@ChangesTableName + '
       select ''DATA TYPE CHANGE'', c1.table_name, c1.COLUMN_NAME, c1.DATA_TYPE,c2.table_name,c2.DATA_TYPE 
       from [INFORMATION_SCHEMA].[COLUMNS] c1
       full outer join [INFORMATION_SCHEMA].[COLUMNS] c2 on c1.COLUMN_NAME=c2.COLUMN_NAME and c2.TABLE_SCHEMA = '''+@NewTableSchema +'''      and c2.TABLE_NAME='''+@NewTable+''' 
       where c1.TABLE_NAME='''+@SourceTable+'''
       and c1.TABLE_SCHEMA = '''+@SourceTableSchema +'''
       and c1.data_type<>c2.DATA_TYPE'
EXEC (@SQLSelect)
print @SQLSelect

/* 
       Step 2: new fields that exist in the second table 
*/
SELECT @SQLSelect = 'INSERT INTO '+@ChangesTableName + ' (ChangeType, SourceTableName, ColumnName, OldDataType) 
              select ''MISSING FIELD'', c2.table_name,c2.COLUMN_NAME, c2.DATA_TYPE
              from [INFORMATION_SCHEMA].[COLUMNS] c2 
              where table_name='''+@SourceTable +''' 
              and c2.COLUMN_NAME not in (select column_name 
                     from [INFORMATION_SCHEMA].[COLUMNS] 
                     where table_name='''+@NewTable+''')
              and c2.TABLE_SCHEMA = '''+@SourceTableSchema +''''
EXEC (@SQLSelect)

/* 
       Step 3: Are any fields in the original table missing from the new table?
*/     
SELECT @SQLSelect = 'INSERT INTO '+@ChangesTableName + ' (ChangeType, NewTableName, ColumnName, NewDataType) 
              select ''NEW FIELD ADDED'', c2.table_name,c2.COLUMN_NAME, c2.DATA_TYPE
              from [INFORMATION_SCHEMA].[COLUMNS] c2
              where table_name='''+@NewTable+'''
                     and c2.COLUMN_NAME not in (select column_name 
                         from [INFORMATION_SCHEMA].[COLUMNS] 
                           where table_name='''+@SourceTable+''')
                           and c2.TABLE_SCHEMA = '''+@NewTableSchema +''''
EXEC (@SQLSelect)

/*
       STEP 4:
       Now, let's compare the 2 tables and report any differences in any data field.
       We do this by generating the Primary Key on the original table, and using that to link to the new table
       Then we build up the common field names; we can only do the compare on those fields, and do a compare on each column of data
*/

SELECT @PrimaryKeySource = ''
SELECT @PrimaryKeyNew = ''
SELECT @PrimaryKeyB = ''
SELECT @WhereSQLClause = ''
SELECT @WhereSQLClauseSource  = ''
SELECT @WhereSQLClauseNew = ''
SELECT @CreateTable = 'CREATE TABLE [dbo].' + @ResultsTableName + ' (ChangeType VARCHAR(100), SourceTableName VARCHAR(MAX), '
SELECT @CreateTableSource = ''
SELECT @CreateTableNew = ''


/* 
       get the primary key from the "new" table 
*/
DECLARE PrimaryKeyCursor CURSOR FAST_FORWARD LOCAL FOR
       SELECT COLUMN_NAME
       FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
       WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
       AND TABLE_NAME = @NewTable AND TABLE_SCHEMA = @NewTableSchema
OPEN PrimaryKeyCursor
FETCH PrimaryKeyCursor INTO @ColumnName
WHILE @@FETCH_STATUS = 0
       BEGIN
              SELECT @PrimaryKeyNew = @primaryKeyNew + '[A].['+@ColumnName + '], '
              SELECT @CreateTableNew = @CreateTableNew + @ColumnName + ' VARCHAR(MAX), '
              SELECT @WhereSQLClauseNew = @WhereSQLClauseNew + '[A].['+@ColumnName +']=[B].['+@ColumnName+'] AND '
              FETCH PrimaryKeyCursor INTO @ColumnName
       END

/* Clean up cursor */
CLOSE PrimaryKeyCursor
DEALLOCATE PrimaryKeyCursor


/* 
       in case the primary key doesn't exist, look at the source table instead 
*/
DECLARE PrimaryKeyCursor CURSOR FAST_FORWARD LOCAL FOR
       SELECT COLUMN_NAME
       FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
       WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + CONSTRAINT_NAME), 'IsPrimaryKey') = 1
       AND TABLE_NAME = @SourceTable AND TABLE_SCHEMA = @SourceTableSchema
OPEN PrimaryKeyCursor
FETCH PrimaryKeyCursor INTO @ColumnName
WHILE @@FETCH_STATUS = 0
       BEGIN
              SELECT @PrimaryKeySource = @primaryKeySource + '[B].['+@ColumnName + '], '
              SELECT @CreateTableSource = @CreateTableSource + @ColumnName + ' VARCHAR(MAX), '
              SELECT @WhereSQLClauseSource = @WhereSQLClauseSource + '[A].['+@ColumnName +']=[B].['+@ColumnName+'] AND '
              FETCH PrimaryKeyCursor INTO @ColumnName
       END

/* Clean up cursor */
CLOSE PrimaryKeyCursor
DEALLOCATE PrimaryKeyCursor


/* Build up the Primary Key */
SELECT @PrimaryKey = CASE WHEN @PrimaryKeyNew = '' THEN @PrimaryKeySource ELSE @PrimaryKeyNew END
SELECT @PrimaryKey = Left(@PrimaryKey, LEN(@PrimaryKey)-1)
SELECT @PrimaryKeyB = REPLACE(@PrimaryKey, '[A]', '[B]')
SELECT @WhereSQLClause = CASE WHEN @PrimaryKeyNew = '' THEN LEFT(@WhereSQLClauseSource, LEN(@WhereSQLClauseSource)-4) ELSE LEFT(@WhereSQLClauseNew, LEN(@WhereSQLClauseNew)-4) END

SELECT @SQLSelect = 'INSERT INTO '+@ChangesTableName + ' (ChangeType, SourceTableName, NewTableName, ColumnName) 
              select ''PRIMARY KEY MISMATCH'', '''+@SourceTable+''', '''+@NewTable+''', Replace('''+@PrimaryKeyB+''', ''[B].'', '''')
              where REPLACE('''+@PrimaryKeyNew+''', ''[A].'', '''')<> REPLACE('''+@PrimaryKeySource+''', ''[B].'', '''')'

EXEC (@SQLSelect)


/* Create the table to store the results */
SELECT @CreateTable = @CreateTable + CASE WHEN @PrimaryKeyNew ='' THEN @CreateTableSource ELSE @CreateTableNew END + ' FieldName VARCHAR(MAX), OldValue VARCHAR(MAX), NewTablename VARCHAR(MAX), NewValue VARCHAR(MAX)) '
EXEC (@CreateTable)


/* Get the column names */
DECLARE LookupCursor CURSOR FAST_FORWARD LOCAL FOR
       SELECT DISTINCT c1.COLUMN_NAME
       from [INFORMATION_SCHEMA].[COLUMNS] c1
       inner join [INFORMATION_SCHEMA].[COLUMNS] c2 on c1.COLUMN_NAME=c2.COLUMN_NAME and c2.TABLE_NAME = @NewTable and c2.TABLE_SCHEMA = @NewTableSchema 
       where c1.TABLE_NAME=@SourceTable 
       and c1.TABLE_SCHEMA = @SourceTableSchema 
       and CASE 
                     WHEN @CheckColumnName = '/*ALL*/' THEN @CheckColumnName
                     ELSE c1.COLUMN_NAME 
              END = @CheckColumnName 
OPEN LookupCursor
FETCH LookupCursor INTO @ColumnName



WHILE @@FETCH_STATUS = 0
       BEGIN

              SELECT @SQLSelect = 'INSERT INTO ' + @ResultsTableName + ' 
                           SELECT ChangeType = ''Value Changed'', '''+@SourceTableFull + ''' as SourceTableName, '+@PrimaryKey + ', '''+@ColumnName +''' AS FieldName, PreviousValue = A.' +@ColumnName 
                           + ', '''+@NewTableFull + ''' as NewTableName, NewValue = B.'+@ColumnName 
                           + ' FROM ' + @SourceTableFull + ' A
                           INNER JOIN '+ @NewTableFull + ' B ON ' + @WhereSQLClause + '
                           ' + @WhereClause + ' [A].['+ @ColumnName+'] <> [b].['+@ColumnName+']'
              EXEC (@SQLSelect )


              SELECT @SQLSelect = 'INSERT INTO ' + @ResultsTableName + ' 
                           SELECT ChangeType = ''Missing Value'', '''+@SourceTableFull + ''' as SourceTableName, '+@PrimaryKey + ', '''+@ColumnName +''' AS FieldName, PreviousValue = A.' +@ColumnName 
                           + ', '''+@NewTableFull + ''' as NewTableName, NewValue = B.'+@ColumnName 
                           + ' FROM ' + @SourceTableFull + ' A
                           LEFT JOIN '+ @NewTableFull + ' B ON ' + @WhereSQLClause + '
                           ' + @WhereClause + ' [b].['+@ColumnName+'] IS NULL AND [A].['+@ColumnName+'] IS NOT NULL'
              EXEC (@SQLSelect )

              SELECT @SQLSelect = 'INSERT INTO ' + @ResultsTableName + ' 
                           SELECT ChangeType = ''New Value'', '''+@SourceTableFull + ''' as SourceTableName, '+@PrimaryKeyB + ', '''+@ColumnName +''' AS FieldName, PreviousValue = A.' +@ColumnName 
                           + ', '''+@NewTableFull + ''' as NewTableName, NewValue = B.'+@ColumnName 
                           + ' FROM ' + @SourceTableFull + ' A
                           RIGHT JOIN '+ @NewTableFull + ' B ON ' + @WhereSQLClause + '
                           ' + @WhereClause + ' [A].['+@ColumnName+'] IS NULL AND [B].['+@ColumnName+'] IS NOT NULL'
              EXEC (@SQLSelect )



              FETCH LookupCursor INTO @ColumnName
       END

/* Clean up cursor */
CLOSE LookupCursor
DEALLOCATE LookupCursor

SELECT @SQLSelect = 'SELECT * FROM [dbo].'+@ChangesTableName +' ORDER BY 1'
EXEC (@SQLSelect)

SELECT @SQLSelect = 'SELECT * FROM [dbo].'+@ResultsTableName +' A ORDER BY 1,2,'+@PrimaryKey 
EXEC (@SQLSelect)


SELECT @SQLSelect = 'DROP TABLE [dbo].'+@ChangesTableName 
EXEC (@SQLSelect)

SELECT @SQLSelect = 'DROP TABLE [dbo].'+@ResultsTableName 
EXEC (@SQLSelect)





GO


