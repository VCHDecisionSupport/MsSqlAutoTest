USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentReasonID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD AssessmentReasonID smallint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AssessmentTypeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD AssessmentTypeID smallint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD SourceReferralID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityDiseaseID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD CommunityDiseaseID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD DeathLocationID smallint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD EthnicityID smallint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD GenderID tinyint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReferralPriorityID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReferralReasonID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD SourceSystemClientID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD DischargeDispositionID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD HSDAID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD CommunityProgramID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ProviderID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD FacilityID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD LevelOfCareId int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'CDPublicHealthMeasureFact') 
BEGIN
	ALTER TABLE dbo.CDPublicHealthMeasureFact ADD ReferralSourceID int;
END
PRINT 'dbo.CDPublicHealthMeasureFact'