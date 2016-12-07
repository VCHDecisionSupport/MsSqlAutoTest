rem https://www.mssqltips.com/sqlservertip/1543/using-sqlcmd-to-execute-multiple-sql-server-scripts/
@ECHO off
mode con lines=32766

ECHO executing batch: %0

SET "pathvar=%cd%"
SET script_path=%pathvar%\sqlcmd_deployment.sql

ECHO starting sql script: %script_path%

SET /P server=Enter Deployment Destination Server:
IF "%server%"=="" (GOTO JustDoIt) ELSE (GOTO DoIt)

:JustDoIt
SET server=STDBDECSUP01
ECHO Default is %server%
GOTO DoIt

:DoIt
echo "deploying to server: %server%" 
rem SQLCMD -S%server% -E -dmaster -m 0 -i "%script_path%" -v pathvar="%pathvar%"
SQLCMD -S%server% -E -m 1 -i "%script_path%" -v pathvar="%pathvar%"
PAUSE

