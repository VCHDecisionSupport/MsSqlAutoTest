
#.\Invoke-SqlCubeUnitTest.ps1
#.\Invoke-MdxCubeUnitTest.ps1
#.\UtilityFunctions.ps1
Function Invoke-CubeUnitTest ($TestSqlServerName, $TestCubeServerName, $UnitTestName)
{
    $ErrorActionPreference = "Stop"
    Write-Host ("Executing UnitTest: {0}" -f $UnitTestName)
   
    ########################     TEMPORARY    ###############################
    $TestDestinationDatabase = "gcDev"
    ########################     TEMPORARY    ###############################

    # create Sql Connection to $TestSqlServerName and Database where dependant procs are deployed
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = "Server='$TestSqlServerName';Database='$TestDestinationDatabase';trusted_connection=true;"
    [void]$SqlConnection.Open()

    # prepare SqlCommand to call stored proc uspInsertCubeUnitTestResults against above SqlConnection 
    $SqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $SqlCommand.CommandText = "uspInsertCubeUnitTestResults"
    $SqlCommand.CommandType = "StoredProcedure"
    $SqlCommand.Connection = $SqlConnection

    # get UnitTest parameters from UnitTestName
    $CubeName = Get-UnitTestCubeName -UnitTestName $UnitTestName
    $Dimension0Name,$Dimension1Name=Get-UnitTestDimensionNames -UnitTestName $UnitTestName
    $MeasureName = Get-UnitTestMeasureName -UnitTestName $UnitTestName

    # Get outputs from Sql script
    $SqlOutput = Invoke-SqlCubeUnitTest -Server $TestSqlServerName -UnitTestName $UnitTestName

    # set Sql proc parameters for Sql UnitTest output
    $TestResultSource = $TestSqlServerName
    [void]$SqlCommand.Parameters.Add("@CubeName", [System.Data.SqlDbType]::String)
    $SqlCommand.Parameters["@CubeName"].Value = $CubeName
    [void]$SqlCommand.Parameters.Add("@TestResultSource", [System.Data.SqlDbType]::String)
    $SqlCommand.Parameters["@TestResultSource"].Value = $TestResultSource
    [void]$SqlCommand.Parameters.Add("@Dimension0Name", [System.Data.SqlDbType]::String)
    $SqlCommand.Parameters["@Dimension0Name"].Value = $Dimension0Name
    [void]$SqlCommand.Parameters.Add("@Dimension1Name", [System.Data.SqlDbType]::String)
    $SqlCommand.Parameters["@Dimension1Name"].Value = $Dimension1Name
    [void]$SqlCommand.Parameters.Add("@MeasureName", [System.Data.SqlDbType]::String)
    $SqlCommand.Parameters["@MeasureName"].Value = $MeasureName
    [void]$SqlCommand.Parameters.Add("@CubeUnitTestResults",[System.Data.SqlDbType]::Structured)
    $SqlCommand.Parameters["@CubeUnitTestResults"].Value = $SqlOutput
    # execute proc and clean up
    [void]$SqlCommand.ExecuteNonQuery()


    # execute proc with Mdx output
    $TestResultSource = $TestCubeServerName

    $MdxOutput = Invoke-MdxCubeUnitTest -Server $TestCubeServerName -UnitTestName $UnitTestName
    $SqlCommand.Parameters["@TestResultSource"].Value = $TestResultSource
    $SqlCommand.Parameters["@CubeUnitTestResults"].Value = $MdxOutput
    [void]$SqlCommand.ExecuteNonQuery()

    [void]$SqlConnection.Close()
}
# Export-ModuleMember -Function Invoke-CubeUnitTest