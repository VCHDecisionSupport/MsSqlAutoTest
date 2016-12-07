--#region dbo.ufnGetColumnNames
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnGetColumnNames';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS nvarchar(max) AS BEGIN DECLARE @return nvarchar(max) RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnGetColumnNames(@pObjectID int)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @return varchar(max) = ''
	SELECT @return=SUBSTRING((
	SELECT ',['+col.AttributePhysicalName +']'
	FROM DQMF.dbo.MD_ObjectAttribute AS col
	WHERE objectid = @pObjectID
	AND IsActive = 1
	ORDER BY col.Sequence
	FOR XML PATH('')),2,5000)
	RETURN @return;
END
GO
--#endregion dbo.ufnGetColumnNames

SELECT dbo.ufnGetColumnNames(53913)
