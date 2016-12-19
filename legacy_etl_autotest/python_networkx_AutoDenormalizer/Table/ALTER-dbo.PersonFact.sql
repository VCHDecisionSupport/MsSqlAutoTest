USE CommunityMart
GO

IF NOT EXISTS(SELECT * FROM sys.columns AS col WHERE col.name = 'EducationLevelID' AND OBJECT_NAME(col.object_id) = 'PersonFact') 
BEGIN
	ALTER TABLE dbo.PersonFact ADD EducationLevelID tinyint;
END
PRINT 'dbo.PersonFact'