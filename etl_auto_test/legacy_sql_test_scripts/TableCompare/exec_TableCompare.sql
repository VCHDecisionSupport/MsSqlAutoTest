USE TestLog
GO

DECLARE @column_pairings ColumnNamePair;
INSERT INTO @column_pairings VALUES ('StartDateID', 'StartDateID');
INSERT INTO @column_pairings VALUES ('EndDateID', 'EndDateID');
DECLARE @A_qualified_key NVARCHAR(128);
DECLARE @B_qualified_key NVARCHAR(128);
SET @A_qualified_key = 'DSDW.Community.MaritalStatusFact.SourceMaritalStatusID'
SET @B_qualified_key = 'DSDW.Staging.CommunityMaritalStatus.SourceMaritalStatusIDNum'

EXEC TestLog.dbo.uspINSTableCompare
	@A_qualified_key
	,@B_qualified_key
	,@column_pairings