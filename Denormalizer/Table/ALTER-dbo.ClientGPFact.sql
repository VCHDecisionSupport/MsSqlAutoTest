USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ClientGPFact') 
	ALTER TABLE dbo.ClientGPFact ADD DeathLocationID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ClientGPFact') 
	ALTER TABLE dbo.ClientGPFact ADD EducationLevelCodeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ClientGPFact') 
	ALTER TABLE dbo.ClientGPFact ADD EthnicityID smallint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ClientGPFact') 
	ALTER TABLE dbo.ClientGPFact ADD GenderID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ClientGPFact') 
	ALTER TABLE dbo.ClientGPFact ADD EducationLevelID tinyint;
