USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmAdverseEventFact') 
BEGIN
	ALTER TABLE dbo.ImmAdverseEventFact ADD DeathLocationID smallint;
END
PRINT 'dbo.ImmAdverseEventFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmAdverseEventFact') 
BEGIN
	ALTER TABLE dbo.ImmAdverseEventFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.ImmAdverseEventFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmAdverseEventFact') 
BEGIN
	ALTER TABLE dbo.ImmAdverseEventFact ADD EthnicityID smallint;
END
PRINT 'dbo.ImmAdverseEventFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmAdverseEventFact') 
BEGIN
	ALTER TABLE dbo.ImmAdverseEventFact ADD GenderID tinyint;
END
PRINT 'dbo.ImmAdverseEventFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmAdverseEventFact') 
BEGIN
	ALTER TABLE dbo.ImmAdverseEventFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.ImmAdverseEventFact'