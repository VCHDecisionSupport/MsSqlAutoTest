USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.strSplit';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS @tblReturn TABLE 
(
	RowID int IDENTITY(1,1),
	Item varchar(max)
)
AS BEGIN DECLARE @return nvarchar(max) RETURN END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO

ALTER FUNCTION [dbo].[strSplit](
	@array varchar(max),
	@del char(1)
)
RETURNS 
@tblReturn TABLE 
(
	RowID int IDENTITY(1,1),
	Item varchar(max)
)
AS

/*
	Copied to CommunityMart: DR8429 2016-03-24 Graham Crowell
	Programmed By: James.Pua
	
	Split string and delimiter into table
		SELECT * FROM [dbo].[strSplit] ('a,b,e,h,c,d,f,g', ',')
		SELECT * FROM [dbo].[strSplit] ('a', ',')
*/
BEGIN
	DECLARE @tblTmp TABLE 
	(
		RowID int IDENTITY(1,1),
		Item varchar(max)
	)
	
	SET @array = RTRIM(LTRIM(@array))
	IF RIGHT(@array, LEN(@del)) <> @del 
		SET @array 	= @array + @del

	;WITH recursiveCTE (item,list) AS
	(
		SELECT SUBSTRING(@array,1,CHARINDEX(@del,@array,1) - 1) as item,
		SUBSTRING(@array,CHARINDEX(@del,@array,1) + 1, LEN(@array)) + @del list

		UNION ALL

		SELECT SUBSTRING(list,1,CHARINDEX(@del,list,1) - 1) as item,
		SUBSTRING(list,CHARINDEX(@del,list,1) + 1, LEN(list)) list
		FROM recursiveCTE R
		WHERE LEN(R.list) > 0
	) INSERT @tblTmp (item) SELECT item FROM recursiveCTE 

	INSERT INTO @tblReturn (item) 
	SELECT item FROM @tblTmp WHERE rowid < (SELECT MAX(Rowid) FROM @tblTmp )

	RETURN 
END


GO


