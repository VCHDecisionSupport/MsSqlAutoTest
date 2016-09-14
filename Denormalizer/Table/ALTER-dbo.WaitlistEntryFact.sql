USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD WaitlistTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
	ALTER TABLE dbo.WaitlistEntryFact ADD LevelOfCareId int;
