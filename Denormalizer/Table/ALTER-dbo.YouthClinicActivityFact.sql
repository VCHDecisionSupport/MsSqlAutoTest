USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentReasonID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD AssessmentReasonID smallint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentTypeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD AssessmentTypeID smallint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD SourceReferralID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityDiseaseID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD CommunityDiseaseID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD DeathLocationID smallint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD EthnicityID smallint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD GenderID tinyint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReferralPriorityID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReferralReasonID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD SourceSystemClientID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD DischargeDispositionID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD HSDAID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD CommunityProgramID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ProviderID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD FacilityID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD LevelOfCareId int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.YouthClinicActivityFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'YouthClinicActivityFact') 
BEGIN
	ALTER TABLE dbo.YouthClinicActivityFact ADD ReferralSourceID int;
END
PRINT 'dbo.YouthClinicActivityFact'