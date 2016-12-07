	PRINT '
	executing sqlcmd_deployment.sql with variable pathvar $(pathvar)'

DECLARE @path varchar(500) = '$(pathvar)'
RAISERROR('@path = $(pathvar) = %s

',0,1,@path) WITH NOWAIT

IF @@SERVERNAME LIKE '%DBDECSUP%'
BEGIN
	PRINT @@SERVERNAME
	:r $(pathvar)\msdb\scripts\UPDATE-TablesToCopy.sql
	:r $(pathvar)\DQMF\Database\Table\TABLE-dbo.ETL_PackageObject.sql
	:r $(pathvar)\DQMF\Database\Table\ALTER-dbo.MD_ObjectAttribute.sql
	:r $(pathvar)\DQMF\Database\Procedure\ALTER-dbo.SetAuditPackageExecution.sql
END
 :r $(pathvar)\AutoTest\Database\DATABASE-AutoTest.sql
 :r $(pathvar)\AutoTest\Database\SCHEMA-SnapShot.sql

 :r $(pathvar)\AutoTest\Database\Table\ColumnHistogram.sql
 :r $(pathvar)\AutoTest\Database\Table\ColumnHistogramType.sql
 :r $(pathvar)\AutoTest\Database\Table\ColumnProfile.sql
 :r $(pathvar)\AutoTest\Database\Table\ColumnProfileType.sql
 :r $(pathvar)\AutoTest\Database\Table\TableProfile.sql
 :r $(pathvar)\AutoTest\Database\Table\TableProfileType.sql
 :r $(pathvar)\AutoTest\Database\Table\TestConfig.sql
 :r $(pathvar)\AutoTest\Database\Table\TestType.sql
 :r $(pathvar)\AutoTest\Database\Table\ForeignKeys.sql

:r $(pathvar)\AutoTest\Database\Function\dbo.strSplit.sql
:r $(pathvar)\AutoTest\Database\Function\dbo.ufnPrettyDateDiff.sql

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
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspAdHocTableViewProfile.sql
:r $(pathvar)\AutoTest\Database\Procedure\dbo.uspAdHocDataProfile.sql

:r $(pathvar)\unittests\dbo.uspDiffMaker.sql
:r $(pathvar)\unittests\dbo.uspLog.sql

-- :r $(pathvar)\msdb\scripts\CREATE-Job.sql
:r $(pathvar)\msdb\scripts\CREATE-AutoTestProfileJob.sql
