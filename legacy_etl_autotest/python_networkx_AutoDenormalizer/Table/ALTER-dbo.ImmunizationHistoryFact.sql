USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD DeathLocationID smallint;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EthnicityID smallint;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD GenderID tinyint;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD HSDAID int;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD CommunityProgramID int;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD ProviderID int;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD FacilityID int;
END
PRINT 'dbo.ImmunizationHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'ImmunizationHistoryFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationHistoryFact ADD LevelOfCareId int;
END
PRINT 'dbo.ImmunizationHistoryFact'