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
	WHEN DATEDIFF(hour, tlog.TestDate, GETDATE()) = 0
		THEN FORMATMESSAGE('%i minutes', DATEDIFF(minute, tlog.TestDate, GETDATE()))
	WHEN DATEDIFF(day, tlog.TestDate, GETDATE()) = 0
		THEN FORMATMESSAGE('%i hours', DATEDIFF(hour, tlog.TestDate, GETDATE()))
	ELSE FORMATMESSAGE('%i days', DATEDIFF(day, tlog.TestDate, GETDATE()))
	-- PRINT @return
	RETURN @return;
END
GO
--#endregion dbo.ufnPrettyDateDiff


