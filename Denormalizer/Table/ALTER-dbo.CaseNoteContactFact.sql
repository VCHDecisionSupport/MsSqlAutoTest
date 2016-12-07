USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CaseNoteReasonID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD CaseNoteReasonID smallint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CaseNoteTypeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD CaseNoteTypeID smallint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceReferralID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD SourceReferralID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD SourceSystemClientID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD DeathLocationID smallint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD EthnicityID smallint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD GenderID tinyint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReferralPriorityID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReferralReasonID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD SourceSystemClientID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD DischargeDispositionID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD HSDAID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD CommunityProgramID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ProviderID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD FacilityID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD LevelOfCareId int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.CaseNoteContactFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'CaseNoteContactFact') 
BEGIN
	ALTER TABLE dbo.CaseNoteContactFact ADD ReferralSourceID int;
END
PRINT 'dbo.CaseNoteContactFact'