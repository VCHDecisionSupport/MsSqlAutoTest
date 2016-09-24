
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN ProviderID int NULL;
	PRINT 'CommunityMart.Dim.Provider.ProviderID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN WaitlistTypeID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistType.WaitlistTypeID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'SourceWaitlistDefinitionID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN SourceWaitlistDefinitionID int NULL;
	PRINT 'CommunityMart.dbo.WaitlistDefinitionFact.SourceWaitlistDefinitionID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistProviderOfferStatusID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN WaitlistProviderOfferStatusID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistProviderOfferStatus.WaitlistProviderOfferStatusID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistReasonOfferRemovedID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN WaitlistReasonOfferRemovedID tinyint NULL;
	PRINT 'CommunityMart.Dim.WaitlistReasonOfferRemoved.WaitlistReasonOfferRemovedID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN HSDAID int NULL;
	PRINT 'CommunityMart.Dim.HSDA.HSDAID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN FacilityID int NULL;
	PRINT 'CommunityMart.Dim.Facility.FacilityID';
END

USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.WaitlistProviderOfferFact ALTER COLUMN LevelOfCareId int NULL;
	PRINT 'CommunityMart.Dim.LevelOfCare.LevelOfCareId';
END
