PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

USE master
GO

DECLARE @path varchar(500) = '$(pathvar)'
PRINT @path

:r $(pathvar)\TestLog2.sql
:r $(pathvar)\Func\dbo.strSplit.sql
:r $(pathvar)\Proc\dbo.dbo.uspAdHocComparisonSetup.sql
:r $(pathvar)\Proc\dbo.uspGetColumnNames.sql
:r $(pathvar)\Proc\dbo.uspInsColumnHistogram.sql
:r $(pathvar)\Proc\dbo.uspCreateMdObjectSnapShot.sql
:r $(pathvar)\Proc\dbo.uspCreateQuerySnapShot.sql
:r $(pathvar)\Proc\dbo.uspCreateProfile.sql
:r $(pathvar)\Proc\dbo.uspInsTestConfig.sql
:r $(pathvar)\Proc\dbo.uspRegressionTest.sql
:r $(pathvar)\Proc\dbo.dbo.uspPkgExecAutoTest.sql
:r $(pathvar)\Func\dbo.ufnGetSnapShotName.sql
:r $(pathvar)\Proc\ALTER-SetAuditPkgExecution.sql
:r $(pathvar)\Proc\dbo.uspDiffMaker.sql
:r $(pathvar)\Proc\dbo.uspDataCompare.sql
-- :r $(pathvar)\fullTest.sql
