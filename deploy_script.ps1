Clear-Host
Set-Location -Path $PSScriptRoot
Write-Host $PSScriptRoot
$sql_scripts = New-Object System.Collections.ArrayList

# database
[void]$sql_scripts.Add("AutoTest.sql")
# schema and table
[void]$sql_scripts.Add("AutoTest.Map.PackageTable.sql")
# profile tables
[void]$sql_scripts.Add("AutoTest.dbo.TableProfile.sql")
[void]$sql_scripts.Add("AutoTest.dbo.ColumnProfile.sql")
[void]$sql_scripts.Add("AutoTest.dbo.ColumnHistogram.sql")
# views
[void]$sql_scripts.Add("msdb.dbo.vwPackagePath.sql")
[void]$sql_scripts.Add("AutoTest.dbo.vwProfileAge.sql")
# procedures
[void]$sql_scripts.Add("AutoTest.dbo.uspGetColumns.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspGetPackagePath.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspGetTables.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspInsMapPackageTable.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspProfilePackageTables.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspProfileTable.sql")
[void]$sql_scripts.Add("AutoTest.dbo.uspDeleteOldProfiles.sql")
# unit tests
[void]$sql_scripts.Add("unit_tests.sql")
# not used
# [void]$sql_scripts.Add("AutoTest.dbo.Alert.sql")


foreach($sql_script in $sql_scripts)
{
    Write-Host $sql_script
    SQLCMD -S STDBDECSUP01 -E -i $sql_script
}

