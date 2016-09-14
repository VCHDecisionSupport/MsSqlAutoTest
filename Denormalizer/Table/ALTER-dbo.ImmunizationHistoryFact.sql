USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
	ALTER TABLE dbo.ImmunizationHistoryFact ADD LevelOfCareId int;
