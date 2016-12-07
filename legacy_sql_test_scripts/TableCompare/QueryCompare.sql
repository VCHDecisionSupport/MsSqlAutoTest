USE gcDev
GO

IF OBJECT_ID('dbo.uspCompare','P') IS NULL
BEGIN
	PRINT 'dbo.uspCompare'
	EXEC('CREATE PROC dbo.uspCompare AS')
END;
GO

ALTER PROC dbo.uspCompare
	@pDataSetA varchar(MAX)
	,@pDataSetB varchar(MAX)
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'dbo.uspCompare'
	PRINT @pDataSetA
	--PRINT @pDataSetB
	DECLARE @sql varchar(max);
	/*
		each string repersents a dataset to be compared
		fully qualified primary key
	*/
	IF OBJECT_ID('dataA','U') IS NOT NULL
	DROP TABLE dataA;

	SET @sql = 'SELECT sub.* INTO dataA FROM ('+@pDataSetA+') AS sub'
	EXEC(@sql);
	
	PRINT 'select from dataA'

END
GO


DECLARE @pDataSetA NVARCHAR(MAX)
	,@pDataSetB NVARCHAR(MAX);
SET @pDataSetA = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID'
SET @pDataSetB = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum'

DECLARE @pQuery1 varchar(MAX) = 'SELECT SourceSystemClientID FROM CommunityMart.dbo.PersonFact'
	,@pQuery2 varchar(MAX) = 'SELECT per_fact.* FROM CommunityMart.dbo.PersonFact AS per_fact'
	,@pPk1 varchar(MAX) = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID'
	,@pPk2 varchar(MAX) = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum'

EXEC dbo.uspCompare @pQuery1, @pQuery2;
