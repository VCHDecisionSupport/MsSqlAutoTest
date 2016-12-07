DECLARE @str varchar(500);
SET @str = '[database].[schema].[table]';
DECLARE @patt varchar(500);
SET @patt = '[ [ a-zA-z]';


SELECT @str WHERE @str LIKE @patt;
