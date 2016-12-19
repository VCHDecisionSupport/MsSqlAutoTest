
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistDefinitionFact ALTER COLUMN ProviderID int NULL;
	PRINT 'CommunityMart.Dim.Provider.ProviderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistDefinitionFact ALTER COLUMN WaitlistTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistType.WaitlistTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistDefinitionFact ALTER COLUMN HSDAID int NULL;
	PRINT 'CommunityMart.Dim.HSDA.HSDAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistDefinitionFact ALTER COLUMN FacilityID int NULL;
	PRINT 'CommunityMart.Dim.Facility.FacilityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistDefinitionFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistDefinitionFact ALTER COLUMN LevelOfCareId int NULL;
	PRINT 'CommunityMart.Dim.LevelOfCare.LevelOfCareId';
END
