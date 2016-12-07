PRINT '
	executing Permissions.sql'

USE TestLog
GO


IF EXISTS(SELECT * FROM sys.database_principals WHERE type = 'R' AND name = 'CommunityAgile')
BEGIN
	PRINT 'CommunityAgile ROLE exists'
END
ELSE 
BEGIN
	PRINT 'CREATE ROLE CommunityAgile'
	CREATE ROLE CommunityAgile AUTHORIZATION db_securityadmin;
END

ALTER ROLE db_datareader ADD MEMBER [CommunityAgile];
GO

GRANT EXECUTE ON OBJECT::dbo.uspINSTableCompare
    TO [CommunityAgile];
GO

GRANT EXEC ON TYPE::[dbo].[ColumnNamePair] 
	TO [CommunityAgile]
GO

