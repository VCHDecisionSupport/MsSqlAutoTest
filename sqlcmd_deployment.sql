PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

USE master
GO

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT

:r $(pathvar)\DQMF\ALTER-dbo.MD_ObjectAttribute.sql
:r $(pathvar)\DQMF\ALTER-dbo.SetAuditPackageExecution.sql
:r $(pathvar)\DQMF\TABLE-dbo.ETL_PackageObject.sql

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
:r $(pathvar)\Database\Procedure\dbo.uspCreateQuerySnapShot.sql
:r $(pathvar)\Database\Procedure\dbo.uspDropSnapShot.sql
:r $(pathvar)\Database\Procedure\dbo.uspGetColumnNames.sql
:r $(pathvar)\Database\Procedure\dbo.uspInsColumnHistogram.sql
:r $(pathvar)\Database\Procedure\dbo.uspCreateProfile.sql
:r $(pathvar)\Database\Procedure\dbo.uspDataCompare.sql
:r $(pathvar)\Database\Procedure\dbo.uspInitPkgRegressionTest.sql
:r $(pathvar)\Database\Procedure\dbo.uspPkgRegressionTest.sql
:r $(pathvar)\Database\Procedure\dbo.uspAdHocDataCompare.sql

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
-- 	\Database\Table\TestConfigLog.sql
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