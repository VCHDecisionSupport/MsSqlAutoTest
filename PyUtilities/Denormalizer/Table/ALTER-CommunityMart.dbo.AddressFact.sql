
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'AddressTypeID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN AddressTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.AddressType.AddressTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HouseTypeID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN HouseTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.HouseType.HouseTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PostalCodeID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN PostalCodeID int NULL;
	PRINT 'CommunityMart.Dim.PostalCode.PostalCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'PatientID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN PatientID int NULL;
	PRINT 'PatientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceSystemClientID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN SourceSystemClientID int NULL;
	PRINT 'CommunityMart.dbo.PersonFact.SourceSystemClientID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'GenderID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN GenderID tinyint NULL;
	PRINT 'CommunityMart.Dim.Gender.GenderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'DeathLocationID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN DeathLocationID smallint NULL;
	PRINT 'CommunityMart.Dim.DeathLocation.DeathLocationID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelCodeID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN EducationLevelCodeID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevelLookup.EducationLevelCodeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EthnicityID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN EthnicityID smallint NULL;
	PRINT 'CommunityMart.Dim.Ethnicity.EthnicityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'AddressFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.AddressFact ALTER COLUMN EducationLevelID tinyint NULL;
	PRINT 'CommunityMart.Dim.EducationLevel.EducationLevelID';
END
