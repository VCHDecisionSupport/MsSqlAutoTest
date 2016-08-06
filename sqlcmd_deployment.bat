rem https://www.mssqltips.com/sqlservertip/1543/using-sqlcmd-to-execute-multiple-sql-server-scripts/
@ECHO off

ECHO executing batch: %0

SET "pathvar=%cd%"
SET script_path=%pathvar%\sqlcmd_deployment.sql

ECHO starting sql script: %script_path%

SET /P server=Enter Deployment Destination Server:
IF "%server%"=="" GOTO JustDoIt
:JustDoIt
SET server=STDBDECSUP01

ECHO Default is %server%
GOTO DoIt

:DoIt
SQLCMD -S%server% -E -dmaster -m 0 -i "%script_path%" -v pathvar="%pathvar%"
PAUSE
