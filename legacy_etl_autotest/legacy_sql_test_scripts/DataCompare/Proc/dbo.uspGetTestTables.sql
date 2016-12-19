--#region CREATE/ALTER PROC
USE DQMF
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspGetTestTables';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspGetTestTables
AS
BEGIN
	SELECT ObjectID
	FROM MD_Object
	where 1=1
	and ObjectPurpose = 'Fact'
	AND ObjectPhysicalName IN ('SLPActivityFact', 'SubstanceUseFact')
END
GO
--#endregion CREATE/ALTER PROC
EXEC DQMF.dbo.uspGetTestTables
