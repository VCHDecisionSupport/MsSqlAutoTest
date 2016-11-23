Set-Location -LiteralPath $PSScriptRoot
$ModuleName="CubeUnitTest"
$ModuleInstallRoot="$env:HOMESHARE\WindowsPowerShell\Modules"
$ModuleInstallFolder="$ModuleInstallRoot\$ModuleName"
$CurrentScriptName=$PSCommandPath.Split("\")[-1]

$ModuleScripts=Get-ChildItem -Filter "*.ps1" | Where-Object {$_.Name -ne $CurrentScriptName}
if(-not(Test-Path -LiteralPath $ModuleInstallFolder))
{
    New-Item -Path $ModuleInstallFolder -ItemType Directory -Force
}
foreach($Script in $ModuleScripts)
{
    #$PSCommandPath
    Write-Host $Script
    Copy-Item -Path $Script -Destination $ModuleInstallFolder -Force
}

#Write-Host $Scripts
# Remove-Item -Path "$ModuleName.psd1"
New-ModuleManifest "$ModuleInstallFolder\$ModuleName.psd1" -ModuleVersion "0.1" -Author "GCrowell" -ScriptsToProcess $ModuleScripts
Test-ModuleManifest -Path "$ModuleInstallFolder\$ModuleName.psd1"

Import-Module -Name CubeUnitTest -Verbose