USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationAlertFact ADD DeathLocationID smallint;
END
PRINT 'dbo.ImmunizationAlertFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationAlertFact ADD EducationLevelCodeID tinyint;
END
PRINT 'dbo.ImmunizationAlertFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationAlertFact ADD EthnicityID smallint;
END
PRINT 'dbo.ImmunizationAlertFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationAlertFact ADD GenderID tinyint;
END
PRINT 'dbo.ImmunizationAlertFact'USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'ImmunizationAlertFact') 
BEGIN
	ALTER TABLE dbo.ImmunizationAlertFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.ImmunizationAlertFact'