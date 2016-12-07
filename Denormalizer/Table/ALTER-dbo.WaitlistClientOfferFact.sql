USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD DeathLocationID smallint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EthnicityID smallint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD GenderID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistTypeID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceSystemClientID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceWaitlistDefinitionID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistPriorityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistPriorityID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitListReasonID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitListReasonID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistStatusID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD SourceWaitlistDefinitionID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistProviderOfferStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistProviderOfferStatusID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistReasonOfferRemovedID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD WaitlistReasonOfferRemovedID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD HSDAID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD CommunityProgramID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD ProviderID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD FacilityID int;
END
PRINT 'dbo.WaitlistClientOfferFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistClientOfferFact') 
BEGIN
	ALTER TABLE dbo.WaitlistClientOfferFact ADD LevelOfCareId int;
END
PRINT 'dbo.WaitlistClientOfferFact'