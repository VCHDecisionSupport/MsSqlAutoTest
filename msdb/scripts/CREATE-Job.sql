
USE msdb
GO

-- https://msdn.microsoft.com/en-us/library/hh510242.aspx
-- https://www.mssqltips.com/sqlservertip/3052/simple-way-to-create-a-sql-server-job-using-tsql/

DELETE DQMF.dbo.ETL_PackageObject

DECLARE @job_name varchar(1000) = 'Populate DQMF ETL_PackageObject';
DECLARE @schedule_name varchar(1000) = 'Populate DQMF ETL_PackageObject';
DECLARE @step_name varchar(1000) = N'execute MSDB parser: PackageTableMapper.exe';
DECLARE @command varchar(1000) = N'\\vhqstdb1\Decision Support Admin\Dev\Exe\PackageTableMapper.exe TestTypeID=1';
DECLARE @output_file_name varchar(1000) = N'\\vhqstdb1\Decision Support Admin\Dev\Exe\PackageTableMapper.txt';

IF EXISTS(SELECT * FROM dbo.sysjobs WHERE name = @job_name)
BEGIN
	EXEC sp_delete_job @job_name =  @job_name
END

EXEC dbo.sp_add_job
    @job_name = @job_name;

EXEC sp_add_jobstep
    @job_name = @job_name,
    @step_name = @step_name,
    @subsystem = N'CmdExec',
    @command=@command, 
	@output_file_name=@output_file_name

EXEC sp_add_jobschedule 
	@job_name = @job_name
	,@name = @schedule_name
	,@freq_type = 8, -- Weekly
    @freq_interval = 64, -- Saturday
    @freq_recurrence_factor = 1, -- every week
    @active_start_time = 20000 -- 2:00 AM

EXEC sp_add_jobserver @job_name = @job_name, @server_name = @@SERVERNAME;

EXEC sp_start_job @job_name = @job_name;

-- SELECT TOP 10 act.job_history_id ,job.name, act.start_execution_date, act.stop_execution_date, hist.message, hist.step_name
-- FROM msdb.dbo.sysjobactivity AS act
-- FULL JOIN msdb.dbo.sysjobs AS job
-- ON act.job_id = job.job_id
-- FULL JOIN msdb.dbo.sysjobhistory AS hist
-- ON act.job_id = hist.job_id
-- AND act.job_history_id = hist.instance_id
-- WHERE 1=1
-- --AND job.name = 'Populate DQMF ETL_PackageObject'
-- AND act.stop_execution_date IS NULL
-- AND act.start_execution_date IS NOT NULL
-- --AND hist.step_name = '(Job outcome)'
-- ORDER BY ISNULL(act.start_execution_date, '1990-01-01') DESC

SELECT * FROM DQMF.dbo.ETL_PackageObject;