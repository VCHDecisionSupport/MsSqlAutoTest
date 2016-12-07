USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD DeathLocationID smallint;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD EthnicityID smallint;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD GenderID tinyint;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD HSDAID int;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD CommunityProgramID int;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD ProviderID int;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD FacilityID int;
END
PRINT 'dbo.WaitTimeFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitTimeFact') 
BEGIN
	ALTER TABLE dbo.WaitTimeFact ADD LevelOfCareId int;
END
PRINT 'dbo.WaitTimeFact'