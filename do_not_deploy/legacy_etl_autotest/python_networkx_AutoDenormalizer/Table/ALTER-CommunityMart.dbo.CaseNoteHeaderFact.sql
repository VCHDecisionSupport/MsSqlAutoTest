
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN SourceReferralID int NULL;
	PRINT 'CommunityMart.dbo.ReferralFact.SourceReferralID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CaseNoteReasonID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN CaseNoteReasonID smallint NULL;
	PRINT 'CommunityMart.Dim.CaseNoteReason.CaseNoteReasonID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CaseNoteTypeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN CaseNoteTypeID smallint NULL;
	PRINT 'CommunityMart.Dim.CaseNoteType.CaseNoteTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN LocalReportingOfficeID int NULL;
	PRINT 'CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN DischargeDispositionID int NULL;
	PRINT 'CommunityMart.Dim.DischargeDisposition.DischargeDispositionID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReasonEndingServiceID int NULL;
	PRINT 'CommunityMart.Dim.ReasonEndingService.ReasonEndingServiceID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReferralPriorityID int NULL;
	PRINT 'CommunityMart.Dim.ReferralPriority.ReferralPriorityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReferralSourceID int NULL;
	PRINT 'CommunityMart.Dim.ReferralSource.ReferralSourceID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReferralSourceLookupID int NULL;
	PRINT 'CommunityMart.Dim.ReferralSourceLookup.ReferralSourceLookupID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ProviderID int NULL;
	PRINT 'CommunityMart.Dim.Provider.ProviderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReferralReasonID int NULL;
	PRINT 'CommunityMart.Dim.ReferralReason.ReferralReasonID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN DischargeDispositionCodeID int NULL;
	PRINT 'CommunityMart.Dim.DischargeDispositionLookupCOM.DischargeDispositionCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN DischargeOutcomeID tinyint NULL;
	PRINT 'CommunityMart.Dim.DischargeOutcome.DischargeOutcomeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReasonEndingServiceCodeID int NULL;
	PRINT 'CommunityMart.Dim.ReasonEndingServiceLookup.ReasonEndingServiceCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN ReferralTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.ReferralType.ReferralTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN HSDAID int NULL;
	PRINT 'CommunityMart.Dim.HSDA.HSDAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN CommunityProgramID int NULL;
	PRINT 'CommunityMart.Dim.CommunityProgram.CommunityProgramID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN FacilityID int NULL;
	PRINT 'CommunityMart.Dim.Facility.FacilityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CaseNoteHeaderFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CaseNoteHeaderFact ALTER COLUMN LevelOfCareId int NULL;
	PRINT 'CommunityMart.Dim.LevelOfCare.LevelOfCareId';
END
