
#Set-Location $PSScriptRoot
..\Install-Module.ps1
Import-Module CubeUnitTest -Verbose
#Get-Module CubeUnitTest
$TestCubeServerName="STDSDB004"
$TestSqlServerName="STDBDECSUP01"
$UnitTestName="ReferralEDVisitCube--ED Visits--Fiscal Year--Chief Complaint System"



Invoke-CubeUnitTest -TestSqlServerName $TestSqlServerName -TestCubeServerName $TestCubeServerName -UnitTestName $UnitTestName

#$SqlOutput=Invoke-UnitTestSqlQuery -Server $TestSqlServerName -UnitTestName $UnitTestName
#$MdxOutput=Invoke-UnitTestMdxQuery -Server $TestCubeServerName -UnitTestName $UnitTestName
