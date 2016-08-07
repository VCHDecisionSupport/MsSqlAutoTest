PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

USE master
GO

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT

:r $(pathvar)\Database\DATABASE-AutoTest.sql
:r $(pathvar)\Database\SCHEMA-SnapShot.sql
:r $(pathvar)\Database\Table\TestConfig.sql
:r $(pathvar)\Database\Table\TestType.sql
:r $(pathvar)\Database\Table\TestConfigSource.sql
:r $(pathvar)\Database\Table\TestConfigLog.sql
:r $(pathvar)\Database\Table\TableProfile.sql
:r $(pathvar)\Database\Table\TableProfileType.sql
:r $(pathvar)\Database\Table\ColumnProfile.sql
:r $(pathvar)\Database\Table\ColumnProfileType.sql
:r $(pathvar)\Database\Table\ColumnHistogram.sql
:r $(pathvar)\Database\Table\ColumnHistogramType.sql

:r $(pathvar)\Database\Function\dbo.ufnGetSnapShotName.sql
:r $(pathvar)\Database\Function\dbo.strSplit.sql

:r $(pathvar)\Database\Procedure\dbo.uspGetKey.sql
:r $(pathvar)\Database\Procedure\dbo.uspDropSnapShot.sql
-- :r $(pathvar)\Database\Procedure\dbo.uspInsTestConfig.sql
:r $(pathvar)\Database\Procedure\dbo.uspGetColumnNames.sql
:r $(pathvar)\Database\Procedure\dbo.uspInsColumnHistogram.sql
:r $(pathvar)\Database\Procedure\dbo.uspCreateProfile.sql
:r $(pathvar)\Database\Procedure\dbo.uspCreateQuerySnapShot.sql
:r $(pathvar)\Database\Procedure\dbo.uspDataCompare.sql
:r $(pathvar)\Database\Procedure\dbo.uspInitPkgRegressionTest.sql
:r $(pathvar)\Database\Procedure\dbo.uspPkgRegressionTest.sql
:r $(pathvar)\Database\Procedure\dbo.uspAdHocDataCompare.sql
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
