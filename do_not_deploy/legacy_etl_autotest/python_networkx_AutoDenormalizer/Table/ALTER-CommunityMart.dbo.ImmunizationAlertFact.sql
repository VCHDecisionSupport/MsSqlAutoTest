
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AntigenID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN AntigenID int NULL;
	PRINT 'CommunityMart.Dim.Antigen.AntigenID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ImmAlertID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN ImmAlertID int NULL;
	PRINT 'CommunityMart.Dim.ImmAlert.ImmAlertID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ImmCategoryID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN ImmCategoryID int NULL;
	PRINT 'CommunityMart.Dim.ImmCategory.ImmCategoryID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.ImmunizationAlertFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END
