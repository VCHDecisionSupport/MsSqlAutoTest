USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'ProviderID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
	ALTER TABLE dbo.WaitlistProviderOfferFact ADD ProviderID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'WaitlistTypeID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
	ALTER TABLE dbo.WaitlistProviderOfferFact ADD WaitlistTypeID tinyint;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'HSDAID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
	ALTER TABLE dbo.WaitlistProviderOfferFact ADD HSDAID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'FacilityID' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
	ALTER TABLE dbo.WaitlistProviderOfferFact ADD FacilityID int;
USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'LevelOfCareId' AND OBJECT_NAME(col.object_id) = 'WaitlistProviderOfferFact') 
	ALTER TABLE dbo.WaitlistProviderOfferFact ADD LevelOfCareId int;
