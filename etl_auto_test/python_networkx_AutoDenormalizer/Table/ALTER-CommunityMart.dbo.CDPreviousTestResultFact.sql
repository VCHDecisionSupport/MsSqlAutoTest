
USE CommunityMart
GO

IF EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'CommunityDiseaseID' AND OBJECT_NAME(col.object_id) = 'CDPreviousTestResultFact') 
BEGIN
	ALTER TABLE CommunityMart.dbo.CDPreviousTestResultFact ALTER COLUMN CommunityDiseaseID int NULL;
	PRINT 'CommunityMart.Dim.CommunityDisease.CommunityDiseaseID';
END
