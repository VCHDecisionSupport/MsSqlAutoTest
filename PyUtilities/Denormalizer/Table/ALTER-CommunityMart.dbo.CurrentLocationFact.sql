
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PostalCodeID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN PostalCodeID int NULL;
	PRINT 'CommunityMart.Dim.PostalCode.PostalCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocalReportingOfficeID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN LocalReportingOfficeID int NULL;
	PRINT 'CommunityMart.Dim.LocalReportingOffice.LocalReportingOfficeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LHAID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN LHAID int NULL;
	PRINT 'CommunityMart.Dim.LHA.LHAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LocationTypeID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN LocationTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.LocationType.LocationTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN ProviderID int NULL;
	PRINT 'CommunityMart.Dim.Provider.ProviderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProvinceID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN ProvinceID tinyint NULL;
	PRINT 'CommunityMart.Dim.Province.ProvinceID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN HSDAID int NULL;
	PRINT 'CommunityMart.Dim.HSDA.HSDAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityProgramID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN CommunityProgramID int NULL;
	PRINT 'CommunityMart.Dim.CommunityProgram.CommunityProgramID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN FacilityID int NULL;
	PRINT 'CommunityMart.Dim.Facility.FacilityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'CurrentLocationFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CurrentLocationFact ALTER COLUMN LevelOfCareId int NULL;
	PRINT 'CommunityMart.Dim.LevelOfCare.LevelOfCareId';
END
