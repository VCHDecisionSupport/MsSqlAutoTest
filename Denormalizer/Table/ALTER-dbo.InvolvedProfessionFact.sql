USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD DeathLocationID smallint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD EthnicityID smallint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD GenderID tinyint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionCodeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD DischargeDispositionCodeID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeOutcomeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD DischargeOutcomeID tinyint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD LocalReportingOfficeID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceCodeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReasonEndingServiceCodeID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralPriorityID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReferralPriorityID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralReasonID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReferralReasonID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceLookupID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReferralSourceLookupID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralTypeID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReferralTypeID tinyint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD SourceSystemClientID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD DischargeDispositionID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD HSDAID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD CommunityProgramID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ProviderID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD FacilityID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD LevelOfCareId int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.InvolvedProfessionFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'InvolvedProfessionFact') 
BEGIN
	ALTER TABLE dbo.InvolvedProfessionFact ADD ReferralSourceID int;
END
PRINT 'dbo.InvolvedProfessionFact'