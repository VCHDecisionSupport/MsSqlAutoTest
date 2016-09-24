USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD DeathLocationID smallint;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD EthnicityID smallint;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD GenderID tinyint;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD HSDAID int;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD CommunityProgramID int;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD ProviderID int;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD FacilityID int;
END
PRINT 'dbo.WeightGrowthFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
BEGIN
	ALTER TABLE dbo.WeightGrowthFact ADD LevelOfCareId int;
END
PRINT 'dbo.WeightGrowthFact'