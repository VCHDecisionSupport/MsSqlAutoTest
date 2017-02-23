Param 
(
    [parameter(Mandatory = $true)]
    [ValidateSet('STDBDECSUP01','STDBDECSUP02','STDBDECSUP03','SPDBDECSUP04')]
    [string] $DeploymentSqlServer
)
Set-Location -Path $PSScriptRoot

# # # # these if's are ran when [parameter(Mandatory = $false)]
if($DeploymentSqlServer -eq "")
{
    $LocalDeploymentUserInput = Read-Host -Prompt ("`nNo deployment server specified.`n`tDefault to local machine ({0})?  Y/n" -f $env:ComputerName)
    $LocalDeployment = ($LocalDeploymentUserInput -eq "Y")
    Write-Host $LocalDeployment
}
if($LocalDeployment -eq $true)
{
    $DeploymentSqlServer = $env:ComputerName
}


Write-Host ("`n`n(re)Deploying AutoTest DDL SQL scripts at:`n`t{1}`n to Sql Server: `n`t{0}" -f $DeploymentSqlServer, $PSScriptRoot) 

# hard-code ordered deployment scripts
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
    SQLCMD -S $DeploymentSqlServer -E -i $sql_script
}

