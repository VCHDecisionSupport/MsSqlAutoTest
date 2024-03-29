
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityServiceLocationID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN CommunityServiceLocationID int NULL;
	PRINT 'CommunityMart.Dim.CommunityServiceLocation.CommunityServiceLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.SchoolHistoryFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END
