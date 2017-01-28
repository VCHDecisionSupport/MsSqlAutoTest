
Set-Location $PSScriptRoot
#Get-Module CubeUnitTest
$TestCubeServerName="STDSDB004\tabular"
$TestSqlServerName="STDBDECSUP01"
$UnitTestName="ReferralEDVisitCube--ED Visits--Fiscal Year--Chief Complaint System"



Invoke-CubeUnitTest -TestSqlServerName $TestSqlServerName -TestCubeServerName $TestCubeServerName -UnitTestName $UnitTestName

#$SqlOutput=Invoke-UnitTestSqlQuery -Server $TestSqlServerName -UnitTestName $UnitTestName
#$MdxOutput=Invoke-UnitTestMdxQuery -Server $TestCubeServerName -UnitTestName $UnitTestName
