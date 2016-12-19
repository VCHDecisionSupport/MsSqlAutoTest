/*
	

*/


IF OBJECT_ID('dbo.uspCompare','P') IS NULL
BEGIN
	PRINT 'CREATE PROC dbo.uspCompare';
	DECLARE @sql varchar(max) = 'CREATE PROC dbo.uspCompare AS';
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspCompare 
	@pA varchar(100)
	,@pB varchar(100)
	,@pKey varchar(100)
AS 
BEGIN
	PRINT 'testing'
	DECLARE @sql nvarchar(max);
	DECLARE @fmt nvarchar(max);
	DECLARE @Acount int;
	DECLARE @Bcount int;
	DECLARE @RecordMatchcount int;

	SET @fmt = '
	SELECT @%scount = COUNT(*)
	FROM %s;'

SET @sql = FORMATMESSAGE(@fmt, 'A', @pA)
	EXEC(@sql);
	RAISERROR('%s rowcount: %i',0 ,1 , @pA, @Acount);
	
	SET @sql = FORMATMESSAGE(@fmt, 'B', @pB)
	EXEC(@sql);
	RAISERROR('%s rowcount: %i',0 ,1 , @pB, @Bcount);

	SET @fmt = '
	SELECT @RecordMatchcount = COUNT(*)
	FROM (
		SELECT *
		FROM %s
		INTERSECT
		SELECT *
		FROM %s
	)'
	SET @sql = FORMATMESSAGE(@fmt, @pA, @pB)
	EXEC(@sql);
	RAISERROR('record match %i',0 ,1 , @RecordMatchcount);

END
GO

EXEC dbo.uspCompare 'DQMF.dbo.DQMF_BizRule', 'DQMF.dbo.DQMF_BizRule', 'brid'