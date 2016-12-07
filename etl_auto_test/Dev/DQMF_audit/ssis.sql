USE msdb
GO

--SELECT *
--FROM sysssislog

--SELECT *
--FROM sysssispackagefolders AS dir
--JOIN sysssispackages AS pkg
--ON dir.folderid = pkg.folderid

SELECT TOP 100 *
FROM sysjobs AS job
JOIN sysjobsteps AS step
ON job.job_id = step.job_id
WHERE 1=1
AND job.name LIKE '%Community%'
OR step.step_name LIKE '%Community%'

DECLARE @patt varchar(100) = '%"\[A-Z]%'
DECLARE @patt2 varchar(100) = '%%%[A-Za-z]%"'

SELECT TOP 100 
--job.name AS job_name, step.step_id, step.step_name, step.subsystem, 
step.command
,SUBSTRING(step.command, PATINDEX('%\[A-Za-z]%',step.command), PATINDEX('%/SERVER%',step.command)-5-PATINDEX('%\[A-Za-z]%',step.command))
,PATINDEX('%[A-Za-z\]"%/SERVER%',step.command)-5
,PATINDEX('%\[A-Za-z]%',step.command)
,'sfasfdasdfas'
,REPLACE(REPLACE(REPLACE(SUBSTRING(step.command, 5, PATINDEX('%/SERVER%',step.command)-5), '"\',''),'\"',''),'"','')
,REPLACE(REPLACE(SUBSTRING(step.command, 5, PATINDEX('%/SERVER%',step.command)-5), '"\',''),'\"','')
,REPLACE(SUBSTRING(step.command, 5, PATINDEX('%/SERVER%',step.command)-5), '"\','')
,SUBSTRING(step.command, 5, PATINDEX('%/SERVER%',step.command)-5)
,PATINDEX('%/SERVER%',step.command)
,'asdfasdf'
,SUBSTRING(REPLACE(REPLACE(REPLACE(step.command, '/SQL ', ''), '"', ''), '\\','\'),1,PATINDEX('%/SERVER%',REPLACE(REPLACE(REPLACE(step.command, '/SQL ', ''), '"', ''), '\\','\'))-2)
,REPLACE(REPLACE(REPLACE(step.command, '/SQL ', ''), '"', ''), '\\','\')
,REPLACE(REPLACE(step.command, '/SQL ', ''), '"', '')
,REPLACE(step.command, '/SQL ', '')

--, PATINDEX(@patt, step.command) AS PackageAddressStart, SUBSTRING(step.command, PATINDEX(@patt, step.command), len(step.command)), PATINDEX(@patt2, SUBSTRING(step.command, PATINDEX(@patt, step.command), len(step.command)))
FROM sysjobs AS job
JOIN sysjobsteps AS step
ON job.job_id = step.job_id
WHERE 1=1
AND step.subsystem = 'SSIS'
--AND step.command NOT LIKE '/SQL %s"\%s"%s /SERVER%s'
--AND step.command NOT LIKE @patt

DECLARE @x varchar(max) = '"\PPE\PPE_LoadData\"" /SERVER spdbdecsup04 /CHECKPOINTING OFF /REPORTING E'

--SELECT PATINDEX('"\
