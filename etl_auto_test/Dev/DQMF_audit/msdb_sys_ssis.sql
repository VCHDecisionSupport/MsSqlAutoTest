
--SELECT *
--FROM DQMF.dbo.AuditPkgExecution
--WHERE ParentPkgExecKey IN (
--	SELECT *
--	FROM DQMF.dbo.AuditPkgExecution AS log
--	JOIN DQMF.dbo.ETL_Package AS pkg
--	ON pkg.PkgID = log.PkgKey
--	--where pkg.PkgName LIKE 'CommunityLoadDSDW'
--)


--;WITH jobsteps AS (
--SELECT step.*
--FROM msdb.dbo.sysjobs AS job
--JOIN msdb.dbo.sysjobsteps AS step
--ON job.job_id = step.job_id
--), pkg AS (
--SELECT *
--FROM msdb.dbo.sysssispackages
--)
--SELECT *
--FROM jobsteps
--WHERE command LIKE '%LoadHCRSData\%'



--SELECT step.command
--	,REPLACE(step.command, '\"','')
--FROM msdb.dbo.sysjobs AS job
--JOIN msdb.dbo.sysjobsteps AS step
--ON job.job_id = step.job_id
--WHERE step.subsystem = 'SSIS'


--SELECT *
--FROM msdb.dbo.sysssispackages AS pkg
--JOIN msdb.dbo.sysssispackagefolders

WITH Recurse_Msdb_Path AS (
	SELECT dir.foldername, dir.folderid, dir.parentfolderid,0 AS Level, CAST('' AS varchar(200)) AS dirpath
	FROM msdb.dbo.sysssispackagefolders AS dir
	WHERE dir.parentfolderid IS NULL
	UNION ALL
	SELECT dir.foldername, dir.folderid, dir.parentfolderid, Level + 1, CAST(dirpath AS varchar(100)) + '\' + CAST(dir.foldername AS varchar(99)) AS dirpath
	FROM msdb.dbo.sysssispackagefolders AS dir
	JOIN Recurse_Msdb_Path
	ON dir.parentfolderid = Recurse_Msdb_Path.folderid
), ctepkgpath AS (
	SELECT CAST(dirpath AS varchar(100)) + '\' + CAST(pkg.name AS varchar(99)) AS package_path, Recurse_Msdb_Path.*, pkg.name AS package_name, pkg.id
	FROM Recurse_Msdb_Path
	JOIN msdb.dbo.sysssispackages AS pkg
	ON pkg.folderid = Recurse_Msdb_Path.folderid
), ctejobstep AS (
	SELECT 
	CASE
        WHEN act.start_execution_date IS NULL THEN 'Not running'
        WHEN act.start_execution_date IS NOT NULL AND act.stop_execution_date IS NULL THEN 'Running'
        WHEN act.start_execution_date IS NOT NULL AND act.stop_execution_date IS NOT NULL THEN 'Not running'
    END AS 'RunStatus'
	,step.step_name, step.step_id, step.subsystem, step.command
	,job.name AS job_name, job.date_created, job.date_modified
	,ctepkgpath.package_name, ctepkgpath.package_path
	,act.start_execution_date AS job_start_date, act.stop_execution_date AS job_stop_date
	--CASE WHEN CONVERT(int, act.start_execution_date, 112)
	,step.last_run_date, step.last_run_duration
	--,hist.run_date, hist.run_status
	FROM msdb.dbo.sysjobsteps AS step
	JOIN msdb.dbo.sysjobs AS job
	ON step.job_id = job.job_id
	JOIN msdb.dbo.sysjobactivity AS act
	ON job.job_id = act.job_id
	--JOIN msdb.dbo.sysjobhistory AS hist
	--ON job.job_id = hist.job_id
	--AND hist.step_id = step.step_id
	LEFT JOIN ctepkgpath
	ON step.command LIKE '%' + CAST(ctepkgpath.package_path AS varchar(500)) + '%' 
)
SELECT ctejobstep.RunStatus, ctejobstep.job_name, ctejobstep.step_id, ctejobstep.step_name, ctejobstep.subsystem, ctejobstep.package_name, ctejobstep.package_path, ctejobstep.command, ctejobstep.job_start_date, ctejobstep.job_stop_date, ctejobstep.*
FROM ctejobstep
--WHERE ctejobstep.job_stop_date IS NULL
--OR ctejobstep.job_start_date IS NULL
ORDER BY ISNULL(ctejobstep.job_stop_date, DATEADD(day,10,GETDATE())) DESC, ctejobstep.job_start_date DESC, ctejobstep.job_name, ctejobstep.step_id
--JOIN step
--ON step.command LIKE '%'+CAST(pkgpath.pkgpath AS varchar(500)) + '%' 

--SELECT * FROM msdb.dbo.sysssispackages
----ORDER BY name
--WHERE '/SQL "\Fin\FinancePHC\Load_NonLabourFact_PHC" /SERVER SPDBDECSUP04 /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E' LIKE '%'+CAST(name AS varchar(500)) + '%' 



----IF '%Load_NonLabourFact_PHC%' LIKE '/SQL "\Fin\FinancePHC\Load_NonLabourFact_PHC" /SERVER SPDBDECSUP04 /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'
--IF 'Load_NonLabourFact_PHC' LIKE '%Load_NonLabourFact_PHC%'
--BEGIN
--	PRINT 'sdfsa'
--END
