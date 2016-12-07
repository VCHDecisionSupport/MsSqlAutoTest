
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN LocalReportingOfficeID int NULL;
	PRINT 'CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN ProviderID int NULL;
	PRINT 'CommunityMart.Dim.Provider.ProviderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN WaitlistTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistType.WaitlistTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN SourceWaitlistDefinitionID int NULL;
	PRINT 'CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistPriorityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN WaitlistPriorityID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistPriority.WaitlistPriorityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitListReasonID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN WaitListReasonID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitListReason.WaitListReasonID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN WaitlistStatusID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistStatus.WaitlistStatusID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN HSDAID int NULL;
	PRINT 'CommunityMart.Dim.HSDA.HSDAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN CommunityProgramID int NULL;
	PRINT 'CommunityMart.Dim.CommunityProgram.CommunityProgramID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN FacilityID int NULL;
	PRINT 'CommunityMart.Dim.Facility.FacilityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistEntryFact ALTER COLUMN LevelOfCareId int NULL;
	PRINT 'CommunityMart.Dim.LevelOfCare.LevelOfCareId';
END
