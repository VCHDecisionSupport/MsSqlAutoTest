USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD LocalReportingOfficeID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceSystemClientID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceWaitlistDefinitionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistPriorityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistPriorityID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitListReasonID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitListReasonID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistStatusID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceWaitlistDefinitionID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistProviderOfferStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistProviderOfferStatusID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistReasonOfferRemovedID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistReasonOfferRemovedID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
	ALTER TABLE dbo.WaitlistClientOfferFact ADD LevelOfCareId int;
