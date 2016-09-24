USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD DeathLocationID smallint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD EthnicityID smallint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD GenderID tinyint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReferralPriorityID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReferralReasonID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD SourceSystemClientID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD DischargeDispositionID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD HSDAID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD CommunityProgramID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ProviderID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD FacilityID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD LevelOfCareId int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.AssessmentHeaderFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'AssessmentHeaderFact') 
BEGIN
	ALTER TABLE dbo.AssessmentHeaderFact ADD ReferralSourceID int;
END
PRINT 'dbo.AssessmentHeaderFact'