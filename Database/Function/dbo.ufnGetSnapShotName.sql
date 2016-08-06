--#region dbo.ufnGetSnapShotName
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnGetSnapShotName';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS varchar(200) AS BEGIN DECLARE @return varchar(200) RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@name, 1, 1) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnGetSnapShotName(@pPrefix varchar(50) = NULL, @pDataRequestID int = NULL, @pDataDesc varchar(100), @pPkgExecKey int = NULL, @pSuffix varchar(50) = NULL)
RETURNS varchar(200)
AS
BEGIN
	DECLARE @dr varchar(100) = (CASE WHEN @pDataRequestID IS NULL THEN '' ELSE 'DR'+CAST(@pDataRequestID AS varchar) END);
	DECLARE @PkgExec varchar(100) = (CASE WHEN @pPkgExecKey IS NULL THEN 'Adhoc' ELSE 'PkgExecKey'+CAST(@pPkgExecKey AS varchar) END);
	DECLARE @return varchar(200) = FORMATMESSAGE('%s%s%s%s%s',ISNULL(@pPrefix,''), @dr, @pDataDesc, @PkgExec, ISNULL(@pSuffix,''));
	RETURN @return;
END
GO
--#endregion dbo.ufnGetSnapShotName
-- DECLARE @pDataRequestID int, @pPkgExecKey int, @pDataDesc varchar(100);
-- SET @pDataRequestID = 666;
-- SET @pPkgExecKey = 1;
-- SET @pDataDesc = 'DataDoom';
-- SELECT @pDataRequestID AS DataRequestTestConfigLogID, @pPkgExecKey AS PkgExecKey, @pDataDesc AS ObjectName, dbo.ufnGetSnapShotName(NULL, @pDataRequestID, @pDataDesc, @pPkgExecKey, NULL) AS ufnGetSnapShotName;
