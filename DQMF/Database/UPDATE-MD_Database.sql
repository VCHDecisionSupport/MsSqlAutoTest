USE DQMF
GO

UPDATE DQMF.dbo.MD_Database 
SET DatabaseName = LTRIM(RTRIM(DatabaseName))
