USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeDispositionCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeOutcomeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD LocalReportingOfficeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReasonEndingServiceCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralPriorityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralReasonID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralSourceLookupID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD SourceSystemClientID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeDispositionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD LevelOfCareId int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReasonEndingServiceID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralSourceID int;
