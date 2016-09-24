USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentReasonID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD AssessmentReasonID smallint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentTypeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD AssessmentTypeID smallint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD SourceReferralID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD DeathLocationID smallint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD EthnicityID smallint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD GenderID tinyint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReferralPriorityID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReferralReasonID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD SourceSystemClientID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD DischargeDispositionID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD HSDAID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD CommunityProgramID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ProviderID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD FacilityID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD LevelOfCareId int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.HoNOSFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'HoNOSFact') 
BEGIN
	ALTER TABLE dbo.HoNOSFact ADD ReferralSourceID int;
END
PRINT 'dbo.HoNOSFact'