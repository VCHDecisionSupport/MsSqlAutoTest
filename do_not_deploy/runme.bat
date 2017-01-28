SET test_script = "Z:\GITHUB\AutoTest\simple_profiles\testscript.sql"
ECHO %test_script%
sqlcmd -v ColumnName="FirstName" -i %test_script%