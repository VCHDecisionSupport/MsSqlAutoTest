USE TestLog
GO

EXEC sp_MSforeachtable 'IF PARSENAME(''?'',2) = ''SnapShot'' BEGIN PRINT ''?'' DROP TABLE ?; END'