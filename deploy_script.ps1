Set-Location -Path $PSScriptRoot
$sql_scripts = Get-Childitem -Filter "*.sql"
$sql_scripts
foreach($sql_script in $sql_scripts)
{
    Write-Host $sql_script
    SQLCMD -S localhost -E -i $sql_script

}