USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE dbo.SchoolHistoryFact ADD DeathLocationID smallint;
END
PRINT 'dbo.SchoolHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE dbo.SchoolHistoryFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.SchoolHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE dbo.SchoolHistoryFact ADD EthnicityID smallint;
END
PRINT 'dbo.SchoolHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE dbo.SchoolHistoryFact ADD GenderID tinyint;
END
PRINT 'dbo.SchoolHistoryFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'SchoolHistoryFact') 
BEGIN
	ALTER TABLE dbo.SchoolHistoryFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.SchoolHistoryFact'