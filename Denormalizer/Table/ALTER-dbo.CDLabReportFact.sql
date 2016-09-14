USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentReasonID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD AssessmentReasonID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentTypeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD AssessmentTypeID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD SourceReferralID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityDiseaseID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD CommunityDiseaseID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD DischargeDispositionCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD DischargeOutcomeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD LocalReportingOfficeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReasonEndingServiceCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReferralPriorityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReferralReasonID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReferralSourceLookupID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReferralTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD SourceSystemClientID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD DischargeDispositionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD LevelOfCareId int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReasonEndingServiceID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'CDLabReportFact') 
	ALTER TABLE dbo.CDLabReportFact ADD ReferralSourceID int;
