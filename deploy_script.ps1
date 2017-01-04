Clear-Host
Set-Location -Path $PSScriptRoot
Write-Host $PSScriptRoot
$sql_scripts = New-Object System.Collections.ArrayList
[void]$sql_scripts.Add("CREATE AutoTest tables.sql")
[void]$sql_scripts.Add("CREATE Map.PackageTable.sql")
[void]$sql_scripts.Add("dbo.uspDeleteOldProfiles.sql")
[void]$sql_scripts.Add("dbo.uspGetTables.sql")
[void]$sql_scripts.Add("dbo.uspGetColumns.sql")
[void]$sql_scripts.Add("dbo.uspProfileTable.sql")
[void]$sql_scripts.Add("dbo.uspProfilePackageTables.sql")
[void]$sql_scripts.Add("dbo.uspProfilePackageTables.sql")
[void]$sql_scripts.Add("dbo.uspUpdateAlerts.sql")
[void]$sql_scripts.Add("dbo.vwProfileAge.sql")


foreach($sql_script in $sql_scripts)
{
    Write-Host $sql_script
    SQLCMD -S localhost -E -i $sql_script
}

