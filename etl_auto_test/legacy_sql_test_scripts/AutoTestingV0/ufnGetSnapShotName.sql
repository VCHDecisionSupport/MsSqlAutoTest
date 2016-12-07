--#region dbo.ufnGetSnapShotName
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnGetSnapShotName';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS varchar(200) AS BEGIN DECLARE @return varchar(200) RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnGetSnapShotName(@pPrefix varchar(50) = NULL, @pDataRequestID int = NULL, @pDataDesc varchar(100), @pPkgExecKey int, @pSuffix varchar(50) = NULL)
RETURNS varchar(200)
AS
BEGIN
	DECLARE @dr varchar(100) = (CASE WHEN @pDataRequestID IS NULL THEN '' ELSE 'DR'+CAST(@pDataRequestID AS varchar) END);
	DECLARE @return varchar(200) = FORMATMESSAGE('%s%s%sPkgExecKey%i%s',ISNULL(@pPrefix,''), @dr, @pDataDesc, @pPkgExecKey, ISNULL(@pSuffix,''));
	--PRINT 'fuck it'
	RETURN @return;
END
GO
--#endregion dbo.ufnGetSnapShotName
DECLARE @pDataRequestID int, @pPkgExecKey int, @pDataDesc varchar(100);
SET @pDataRequestID = 666;
SET @pPkgExecKey = 1;
SET @pDataDesc = 'DataDoom';
SELECT @pDataRequestID AS DataRequestTestConfigID, @pPkgExecKey AS PkgExecKey, @pDataDesc AS ObjectName, dbo.ufnGetSnapShotName(NULL, @pDataRequestID, @pDataDesc, @pPkgExecKey, NULL) AS ufnGetSnapShotName;
