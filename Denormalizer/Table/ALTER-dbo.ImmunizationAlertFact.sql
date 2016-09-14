USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
	ALTER TABLE dbo.ImmunizationAlertFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
	ALTER TABLE dbo.ImmunizationAlertFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
	ALTER TABLE dbo.ImmunizationAlertFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
	ALTER TABLE dbo.ImmunizationAlertFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
	ALTER TABLE dbo.ImmunizationAlertFact ADD EducationLevelID tinyint;
