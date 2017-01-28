Set-Location -LiteralPath $PSScriptRoot
$ModuleName="CubeUnitTest"
$ModuleInstallRoot="$Env:ProgramFiles\WindowsPowerShell\Modules"
$ModuleInstallFolder="$ModuleInstallRoot\$ModuleName"
$CurrentScriptName=$PSCommandPath.Split("\")[-1]
$functions = "Get-UnitTestMeasureName","Get-UnitTestDimensionNames","Get-UnitTestSqlQuery","ConvertTo-CleanName","ConvertTo-SafeName","Get-UnitTestCubeName","Get-UnitTestMeasure","Get-UnitTestMdxQuery","Get-CubeProcessDate","Invoke-UnitTestMdxQuery","Invoke-UnitTestSqlQuery","Invoke-CubeUnitTest"

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
New-ModuleManifest "$PSScriptRoot\$ModuleName\$ModuleName.psd1" -ModuleVersion "0.1" -Author "GCrowell" -FunctionsToExport $functions
New-ModuleManifest "$ModuleInstallFolder\$ModuleName.psd1" -ModuleVersion "0.1" -Author "GCrowell" -FunctionsToExport $functions
Test-ModuleManifest -Path "$ModuleInstallFolder\$ModuleName.psd1"

Import-Module -Name CubeUnitTest -Verbose