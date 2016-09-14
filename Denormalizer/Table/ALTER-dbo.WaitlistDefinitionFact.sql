USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
	ALTER TABLE dbo.WaitlistDefinitionFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
	ALTER TABLE dbo.WaitlistDefinitionFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
	ALTER TABLE dbo.WaitlistDefinitionFact ADD LevelOfCareId int;
