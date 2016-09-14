USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD EducationLevelID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD CommunityProgramID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WeightGrowthFact') 
	ALTER TABLE dbo.WeightGrowthFact ADD LevelOfCareId int;
