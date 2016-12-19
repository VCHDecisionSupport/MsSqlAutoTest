rem https://www.mssqltips.com/sqlservertip/1543/using-sqlcmd-to-execute-multiple-sql-server-scripts/
@ECHO off

ECHO executing batch: %0

SET "pathvar=%cd%"
SET script_path=%pathvar%\sqlcmd_deployment.sql

ECHO starting sql script: %script_path%

SQLCMD -SSTDBDECSUP01 -E -dmaster -i "%script_path%" -v pathvar="%pathvar%"
PAUSE