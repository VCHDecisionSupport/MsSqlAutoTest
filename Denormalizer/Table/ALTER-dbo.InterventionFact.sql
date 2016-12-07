USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD DeathLocationID smallint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD EthnicityID smallint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD GenderID tinyint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReferralPriorityID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReferralReasonID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD SourceSystemClientID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD DischargeDispositionID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD HSDAID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'InterventionTypeID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD InterventionTypeID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD CommunityProgramID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ProviderID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD FacilityID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD LevelOfCareId int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.InterventionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'InterventionFact') 
BEGIN
	ALTER TABLE dbo.InterventionFact ADD ReferralSourceID int;
END
PRINT 'dbo.InterventionFact'