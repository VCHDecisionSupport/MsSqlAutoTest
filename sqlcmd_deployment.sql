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
:r $(pathvar)\Database\Table\TableProfile.sql
:r $(pathvar)\Database\Table\TableProfileType.sql
:r $(pathvar)\Database\Table\ColumnProfile.sql
:r $(pathvar)\Database\Table\ColumnProfileType.sql
:r $(pathvar)\Database\Table\ColumnHistogram.sql
:r $(pathvar)\Database\Table\ColumnHistogramType.sql

:r $(pathvar)\Database\Function\dbo.ufnGetSnapShotName.sql
:r $(pathvar)\Database\Function\dbo.strSplit.sql

:r $(pathvar)\Database\Procedure\dbo.uspGetKey.sql
:r $(pathvar)\Database\Procedure\dbo.uspInsTestConfig.sql
:r $(pathvar)\Database\Procedure\dbo.uspCreateQuerySnapShot.sql
:r $(pathvar)\Database\Procedure\dbo.uspPkgExecAutoTest.sql
:r $(pathvar)\Database\Procedure\dbo.uspGetColumnNames.sql
:r $(pathvar)\Database\Procedure\dbo.uspAdHocComparisonSetup.sql
:r $(pathvar)\Database\Procedure\dbo.uspCreateProfile.sql
:r $(pathvar)\Database\Procedure\dbo.uspDataCompare.sql
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\
-- :r $(pathvar)\Database\Procedure\


-- :r $(pathvar)\Func\dbo.strSplit.sql
-- :r $(pathvar)\Proc\dbo.dbo.uspAdHocComparisonSetup.sql
-- :r $(pathvar)\Proc\dbo.uspGetColumnNames.sql
-- :r $(pathvar)\Proc\dbo.uspInsColumnHistogram.sql
-- :r $(pathvar)\Proc\dbo.uspCreateMdObjectSnapShot.sql
-- :r $(pathvar)\Proc\dbo.uspCreateQuerySnapShot.sql
-- :r $(pathvar)\Proc\dbo.uspCreateProfile.sql
-- :r $(pathvar)\Proc\dbo.uspInsTestConfig.sql
-- :r $(pathvar)\Proc\dbo.uspRegressionTest.sql
-- :r $(pathvar)\Proc\dbo.dbo.uspPkgExecAutoTest.sql
-- :r $(pathvar)\Func\dbo.ufnGetSnapShotName.sql
-- :r $(pathvar)\Proc\ALTER-SetAuditPkgExecution.sql
-- :r $(pathvar)\Proc\dbo.uspDiffMaker.sql
-- :r $(pathvar)\Proc\dbo.uspDataCompare.sql
-- -- :r $(pathvar)\fullTest.sql
