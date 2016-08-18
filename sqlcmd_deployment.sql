PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

USE master
GO

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT

:r $(pathvar)\DQMF\Database\Table\TABLE-dbo.ETL_PackageObject.sql
:r $(pathvar)\DQMF\Database\Table\ALTER-dbo.MD_ObjectAttribute.sql
:r $(pathvar)\DQMF\Database\Procedure\ALTER-dbo.SetAuditPackageExecution.sql

:r $(pathvar)\AutoTest\Database\DATABASE-AutoTest.sql
:r $(pathvar)\AutoTest\Database\SCHEMA-SnapShot.sql

:r $(pathvar)\AutoTest\Database\Table\TestConfig.sql
:r $(pathvar)\AutoTest\Database\Table\TestType.sql
:r $(pathvar)\AutoTest\Database\Table\TableProfile.sql
:r $(pathvar)\AutoTest\Database\Table\TableProfileType.sql
:r $(pathvar)\AutoTest\Database\Table\ColumnProfile.sql
:r $(pathvar)\AutoTest\Database\Table\ColumnProfileType.sql
:r $(pathvar)\AutoTest\Database\Table\ColumnHistogram.sql
:r $(pathvar)\AutoTest\Database\Table\ColumnHistogramType.sql

:r $(pathvar)\AutoTest\Database\Function\dbo.ufnGetSnapShotName.sql
:r $(pathvar)\AutoTest\Database\Function\dbo.strSplit.sql

:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspGetKey.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspCreateQuerySnapShot.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspDropSnapShot.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspGetColumnNames.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspInsColumnHistogram.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspCreateProfile.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspDataCompare.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspInitPkgRegressionTest.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspPkgRegressionTest.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspAdHocDataCompare.sql

:r $(pathvar)\msdb\scripts\CREATE-Job.sql

-- DQMF:
-- 	\DQMF\ALTER-dbo.MD_ObjectAttribute.sql
-- 	\DQMF\ALTER-dbo.SetAuditPackageExecution.sql
-- 	\DQMF\TABLE-dbo.ETL_PackageObject.sql

-- Database:
-- 	\Database\DATABASE-AutoTest.sql
-- 	\Database\SCHEMA-SnapShot.sql
-- 	\Database\Table\TestConfig.sql
-- 	\Database\Table\TestType.sql
-- 	\Database\Table\TestConfigSource.sql
-- 	\Database\Table\TestConfig.sql
-- 	\Database\Table\TableProfile.sql
-- 	\Database\Table\TableProfileType.sql
-- 	\Database\Table\ColumnProfile.sql
-- 	\Database\Table\ColumnProfileType.sql
-- 	\Database\Table\ColumnHistogram.sql
-- 	\Database\Table\ColumnHistogramType.sql
-- 	\Database\Function\dbo.ufnGetSnapShotName.sql
-- 	\Database\Function\dbo.strSplit.sql
-- 	\Database\Procedure\dbo.uspGetKey.sql
-- 	\Database\Procedure\dbo.uspCreateQuerySnapShot.sql
-- 	\Database\Procedure\dbo.uspDropSnapShot.sql
-- 	\Database\Procedure\dbo.uspGetColumnNames.sql
-- 	\Database\Procedure\dbo.uspInsColumnHistogram.sql
-- 	\Database\Procedure\dbo.uspCreateProfile.sql
-- 	\Database\Procedure\dbo.uspDataCompare.sql
-- 	\Database\Procedure\dbo.uspInitPkgRegressionTest.sql
-- 	\Database\Procedure\dbo.uspPkgRegressionTest.sql
-- 	\Database\Procedure\dbo.uspAdHocDataCompare.sql