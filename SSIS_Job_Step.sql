-- creates a job step that that uses CmdExec  
USE msdb;  
GO
EXEC sp_add_jobstep  
    @job_name = N'Populate DQMF ETL_PackageObject',  
    @step_name = N'Just Do it',  
    @subsystem = N'CMDEXEC',  
    @command = 'C:\admin\PackageTableMapper.exe',   
    @retry_attempts = 5,  
    @retry_interval = 5 ;  
GO  

