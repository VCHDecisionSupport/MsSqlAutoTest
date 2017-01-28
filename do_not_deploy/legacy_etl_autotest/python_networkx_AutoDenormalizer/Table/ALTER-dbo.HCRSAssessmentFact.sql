USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD DeathLocationID smallint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD EthnicityID smallint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD GenderID tinyint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralPriorityID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralReasonID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD SourceSystemClientID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD DischargeDispositionID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD HSDAID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD CommunityProgramID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ProviderID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD FacilityID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD LevelOfCareId int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.HCRSAssessmentFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'HCRSAssessmentFact') 
BEGIN
	ALTER TABLE dbo.HCRSAssessmentFact ADD ReferralSourceID int;
END
PRINT 'dbo.HCRSAssessmentFact'