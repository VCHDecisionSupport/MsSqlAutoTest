Function Get-UnitTestMeasureName($UnitTestName)
{
    $ErrorActionPreference = "Stop"
    # "Cube--Measure--Column Dim--Row Dim"
    return $UnitTestName.Split('-')[2]
}

Function Get-UnitTestDimensionNames($UnitTestName)
{
    $ErrorActionPreference = "Stop"
    # "Cube--Measure--Column Dim--Row Dim"
    return $UnitTestName.Split('-')[4],$UnitTestName.Split('-')[6]
}

Function Get-UnitTestSqlQuery ($UnitTestName)
{
    $ErrorActionPreference = "Stop"
	# "Cube--Measure--Column Dim--Row Dim"
    $SqlScriptPath = "$UnitTestName.sql"
    # need to -Raw to maintain line breaks (http://stackoverflow.com/questions/15041857/powershell-keep-text-formatting-when-reading-in-a-file)
    $SqlQuery = Get-Content -Path $SqlScriptPath -Raw
	return $SqlQuery
}

Function ConvertTo-CleanName($name)
{
    return $name.Replace('[','').Replace(']','')
}

Function ConvertTo-SafeName($name)
{
    return "["+$name.Replace(".","].[")+"]"
}

Function Get-UnitTestCubeName($UnitTestName)
{
    $ErrorActionPreference = "Stop"
    # "Cube Name--Measure Name--Column Dim--Row Dim"
    return "["+$UnitTestName.Split('-')[0]+"]"
} 

Function Get-UnitTestMeasure($UnitTestName)
{
    $ErrorActionPreference = "Stop"
    # "Cube Name--Measure Name--Column Dim--Row Dim"
    return "["+$UnitTestName.Split('-')[2]+"]"
} 

Function Get-UnitTestMdxQuery ($UnitTestName)
{
	# "Cube--Measure--Column Dim--Row Dim"
    $ErrorActionPreference = "Stop"
    $MdxScriptPath = "$UnitTestName.mdx"
    
    $MdxQuery = Get-Content -Path $MdxScriptPath -Raw
	return $MdxQuery
}
# Export-ModuleMember -Function Get-UnitTestMeasureName
# Export-ModuleMember -Function Get-UnitTestDimensionNames
# Export-ModuleMember -Function Get-UnitTestSqlQuery
# Export-ModuleMember -Function ConvertTo-CleanName
# Export-ModuleMember -Function ConvertTo-SafeName
# Export-ModuleMember -Function Get-UnitTestCubeName
# Export-ModuleMember -Function Get-UnitTestMeasure
# Export-ModuleMember -Function Get-UnitTestMdxQuery