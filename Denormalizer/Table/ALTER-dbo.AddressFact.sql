USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE dbo.AddressFact ADD DeathLocationID smallint;
END
PRINT 'dbo.AddressFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE dbo.AddressFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.AddressFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE dbo.AddressFact ADD EthnicityID smallint;
END
PRINT 'dbo.AddressFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE dbo.AddressFact ADD GenderID tinyint;
END
PRINT 'dbo.AddressFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE dbo.AddressFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.AddressFact'