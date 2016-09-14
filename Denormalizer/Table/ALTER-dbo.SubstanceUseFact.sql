USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentReasonID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD AssessmentReasonID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentTypeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD AssessmentTypeID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD SourceReferralID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD DischargeDispositionCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD DischargeOutcomeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD LocalReportingOfficeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReasonEndingServiceCodeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReferralPriorityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReferralReasonID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReferralSourceLookupID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReferralTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD SourceSystemClientID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD DischargeDispositionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD LevelOfCareId int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReasonEndingServiceID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'SubstanceUseFact') 
	ALTER TABLE dbo.SubstanceUseFact ADD ReferralSourceID int;
