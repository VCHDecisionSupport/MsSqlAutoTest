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
# DQMF 
[void]$sql_scripts.Add("ExternalObjects/AuditPkgExecution.sql")
# msdb
[void]$sql_scripts.Add("ExternalObjects/msdb.dbo.vwPackagePath.sql")

# AutoTest
# database
[void]$sql_scripts.Add("Database/AutoTest.sql")
# schema and table
[void]$sql_scripts.Add("Database/Table/AutoTest.Map.PackageTable.sql")
# profile tables
[void]$sql_scripts.Add("Database/Table/AutoTest.dbo.TableProfile.sql")
[void]$sql_scripts.Add("Database/Table/AutoTest.dbo.ColumnProfile.sql")
[void]$sql_scripts.Add("Database/Table/AutoTest.dbo.ColumnHistogram.sql")
# view
[void]$sql_scripts.Add("Database/View/AutoTest.dbo.vwProfileAge.sql")
# procedures
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspGetColumns.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspGetPackagePath.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspGetTables.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspInsMapPackageTable.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspProfilePackageTables.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspProfileTable.sql")
[void]$sql_scripts.Add("Database/StoredProcedure/AutoTest.dbo.uspDeleteOldProfiles.sql")
# unit tests
# [void]$sql_scripts.Add("unit_tests.sql")
# not used
# [void]$sql_scripts.Add("AutoTest.dbo.Alert.sql")


foreach($sql_script in $sql_scripts)
{
    Write-Host $sql_script
    SQLCMD -S $DeploymentSqlServer -E -i $sql_script
}

