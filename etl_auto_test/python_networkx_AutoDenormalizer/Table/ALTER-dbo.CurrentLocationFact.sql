USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD DeathLocationID smallint;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD EthnicityID smallint;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD GenderID tinyint;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD HSDAID int;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD HSDAID int;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD CommunityProgramID int;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD ProviderID int;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD FacilityID int;
END
PRINT 'dbo.CurrentLocationFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE dbo.CurrentLocationFact ADD LevelOfCareId int;
END
PRINT 'dbo.CurrentLocationFact'