USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'InterventionID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD InterventionID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ProviderID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD SourceReferralID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD DeathLocationID smallint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD EthnicityID smallint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD GenderID tinyint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralPriorityID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralReasonID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD SourceSystemClientID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD DischargeDispositionID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD HSDAID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'InterventionTypeID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD InterventionTypeID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD CommunityProgramID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ProviderID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD FacilityID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD LevelOfCareId int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.HomeSupportActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'HomeSupportActivityFact') 
BEGIN
	ALTER TABLE dbo.HomeSupportActivityFact ADD ReferralSourceID int;
END
PRINT 'dbo.HomeSupportActivityFact'