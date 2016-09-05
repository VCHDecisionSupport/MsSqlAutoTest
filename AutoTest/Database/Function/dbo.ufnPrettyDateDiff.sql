--#region dbo.ufnPrettyDateDiff
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnPrettyDateDiff';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS varchar(100) AS BEGIN DECLARE @return varchar(100) RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnPrettyDateDiff(@pStartDate datetime, @pEndDate datetime)
RETURNS varchar(100)
AS
BEGIN
	DECLARE @return varchar(100);
	SELECT @return = CASE
	WHEN DATEDIFF(hour, @pStartDate, @pEndDate) = 0
		THEN FORMATMESSAGE('%i minutes', DATEDIFF(MINUTE, @pStartDate, @pEndDate))
	WHEN DATEDIFF(day, @pStartDate, @pEndDate) = 0
		THEN FORMATMESSAGE('%i hours', DATEDIFF(HOUR, @pStartDate, @pEndDate))
	ELSE FORMATMESSAGE('%i days', DATEDIFF(DAY, @pStartDate, @pEndDate))
	END
	-- PRINT @return
	RETURN @return;
END
GO
--#endregion dbo.ufnPrettyDateDiff
--DECLARE @pStartDate datetime = '2016-08-28 09:02'
--DECLARE @pEndDate datetime = '2016-08-30 09:00'

--SELECT dbo.ufnPrettyDateDiff(@pStartDate, @pEndDate)


