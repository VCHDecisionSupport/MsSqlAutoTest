USE msdb
GO

SET NOCOUNT ON;
DELETE DQMF.dbo.ETL_PackageObject

DECLARE @job_name varchar(1000) = 'AutoTest Data Profiles';
RAISERROR(@job_name, 1, 1) WITH NOWAIT;
DECLARE @schedule_name varchar(1000) = @job_name;
DECLARE @step_name varchar(1000);
DECLARE @command varchar(1000);
DECLARE @DatabaseName varchar(100);

IF EXISTS(SELECT * FROM dbo.sysjobs WHERE name = @job_name)
BEGIN
	EXEC sp_delete_job @job_name =  @job_name
END

EXEC dbo.sp_add_job
    @job_name = @job_name;

EXEC dbo.sp_add_jobserver
	@job_name = @job_name

SET @DatabaseName = 'CommunityMart';
SET @step_name = FORMATMESSAGE('Profile %s', @DatabaseName)
SET @command=FORMATMESSAGE('EXEC AutoTest.dbo.uspAdHocDataProfile @pDatabaseName = ''%s''',@DatabaseName);

EXEC sp_add_jobstep
    @job_name = @job_name,
    @step_name = @step_name,
    @subsystem = N'TSQL',
    @command=@command,
	@server=@@SERVERNAME
	

SET @DatabaseName = 'DSDW';
SET @step_name = FORMATMESSAGE('Profile %s', @DatabaseName)
SET @command=FORMATMESSAGE('EXEC AutoTest.dbo.uspAdHocDataProfile @pDatabaseName = ''%s''',@DatabaseName);

EXEC sp_add_jobstep
    @job_name = @job_name,
    @step_name = @step_name,
    @subsystem = N'TSQL',
    @command=@command,
	@server=@@SERVERNAME
