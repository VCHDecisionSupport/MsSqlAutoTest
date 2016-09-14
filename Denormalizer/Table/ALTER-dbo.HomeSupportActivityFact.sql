USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'InterventionID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD InterventionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD SourceReferralID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeDispositionCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeOutcomeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD LocalReportingOfficeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReasonEndingServiceCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralPriorityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralReasonID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralSourceLookupID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD SourceSystemClientID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeDispositionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'InterventionTypeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD InterventionTypeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD LevelOfCareId int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReasonEndingServiceID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralSourceID int;
