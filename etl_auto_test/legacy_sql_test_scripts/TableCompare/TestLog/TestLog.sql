PRINT '
	executing TestLog.sql'

USE master
GO

IF DB_ID('TestLog') IS NULL
BEGIN 
	PRINT 'TestLog database does not exist'
	DECLARE @sql nvarchar(128);
	SET @sql = 'CREATE DATABASE TestLog;'
	EXEC(@sql);
END
ELSE 
BEGIN 
	PRINT 'database already exists'
END
GO
