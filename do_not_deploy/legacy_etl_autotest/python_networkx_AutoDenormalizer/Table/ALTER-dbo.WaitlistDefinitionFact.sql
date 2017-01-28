USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE dbo.WaitlistDefinitionFact ADD HSDAID int;
END
PRINT 'dbo.WaitlistDefinitionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE dbo.WaitlistDefinitionFact ADD FacilityID int;
END
PRINT 'dbo.WaitlistDefinitionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE dbo.WaitlistDefinitionFact ADD LevelOfCareId int;
END
PRINT 'dbo.WaitlistDefinitionFact'