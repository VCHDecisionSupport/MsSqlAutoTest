USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD DeathLocationID smallint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD EthnicityID smallint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD GenderID tinyint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD ProviderID int;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD WaitlistTypeID tinyint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD HSDAID int;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD CommunityProgramID int;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD ProviderID int;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD FacilityID int;
END
PRINT 'dbo.WaitlistEntryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistEntryFact') 
BEGIN
	ALTER TABLE dbo.WaitlistEntryFact ADD LevelOfCareId int;
END
PRINT 'dbo.WaitlistEntryFact'