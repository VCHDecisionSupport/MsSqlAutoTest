USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD DeathLocationID smallint;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD EthnicityID smallint;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD GenderID tinyint;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DischargeDispositionID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD DischargeDispositionID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD HSDAID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD CommunityProgramID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD ProviderID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD FacilityID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD LevelOfCareId int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReasonEndingServiceID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD ReasonEndingServiceID int;
END
PRINT 'dbo.ReferralFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ReferralSourceID' AND OBJECT_NAME(col.object_id) = 'ReferralFact') 
BEGIN
	ALTER TABLE dbo.ReferralFact ADD ReferralSourceID int;
END
PRINT 'dbo.ReferralFact'