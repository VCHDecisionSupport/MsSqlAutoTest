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

Function ConvertTo-CleanName($Name)
{
    return $name.Replace('[','').Replace(']','')
}

Function ConvertTo-SafeName($Name)
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

Function Get-CubeProcessDate($ServerName, $CubeName)
{
    $ServerName = ConvertTo-CleanName -Name $ServerName
    $CubeName = ConvertTo-CleanName -Name $CubeName
    $DmvQuery = "SELECT * FROM `$system.DBSCHEMA_CATALOGS WHERE [CATALOG_NAME] = '$CubeName'"
    ## Prepare the connection string based on information provided
    $OleConnectionString="Data source=$ServerName;Provider=MSOLAP.5;Cube=Model;Initial catalog=$CubeName;"
    ## Connect to the data source and open
    $OleConnection = New-Object System.Data.OleDb.OleDbConnection $OleConnectionString
    $OleConnection.Open()
    #$OleConnection
    $DmvCommand = New-Object System.Data.OleDb.OleDbCommand $DmvQuery, $OleConnection
    #$DmvCommand
    

    ## Fetch the results, and close the connection
    $OleAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $DmvCommand
    #$OleAdapter 
    $Dataset = New-Object System.Data.DataSet
    [void] $OleAdapter.Fill($Dataset)
    $OleConnection.Close()

    ## Return all of the rows from their query
    $Dataset.Tables[0].Rows[0].DATE_MODIFIED
}




# .\UtilityFunctions.ps1
<# 
.SYNOPSIS 
Executes mdx query from mdx script specified by UnitTestName.
.DESCRIPTION 
Executes mdx query from mdx script specified by UnitTestName.
Sql query should return: Dimension0Name ON Columns,Dimension1Name ON Rows, WHERE MeasureName
The records should contain the values that correspond to the column names.
Creates a DataTable sql query from sql script specified by UnitTestName.
DataTable repersents the source of truth for a cube.
.INPUTS 
ServerName 
    Target Sql server that the query will be executed on.
UnitTestName 
    Standard name that follows naming convention: Cube--Measure--Column Dim--Row Dim
.OUTPUTS 
   System.Data.DataTable 
.EXAMPLE 
    figure it out
.NOTES 
    this is defineatly noteworthy
.LINK 
http://thepowershellguy.com/blogs/posh/archive/2007/01/21/powershell-gui-scripblock-monitor-script.aspx 
#> 
Function Invoke-UnitTestMdxQuery ($ServerName, $UnitTestName) { 
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.AdomdClient") | Out-Null
    $ErrorActionPreference = "Stop"
    Write-Host ("Executing Mdx for UnitTest: `n`t{0}" -f $UnitTestName)
    $MdxQuery = Get-UnitTestMdxQuery -UnitTestName $UnitTestName
    $CubeName = Get-UnitTestCubeName -UnitTestName $UnitTestName
    $CubeName = ConvertTo-CleanName -name $CubeName

    # Use ADOMD API to execute Mdx query and populate generic DataSet.DataTable
    $SsasConnectionString="Data source=$ServerName;Provider=MSOLAP.5;Cube=Model;Initial catalog=$CubeName;"
    $SsasConnection = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($SsasConnectionString)
    $SsasConnection.Open() | Out-Null
    $SsasCommand = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdCommand($MdxQuery, $SsasConnection)
    $DataAdapter = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdDataAdapter($SsasCommand) 

    $DataSet = New-Object System.Data.DataSet("MdxCubeQueryResults")
    [void]$DataAdapter.Fill($DataSet)
    [void]$SsasConnection.Close()

    # only 1 table exists in DataSet
    $DataTable=$DataSet.Tables[0]
    
    $MeasureName = Get-UnitTestMeasure -UnitTestName $UnitTestName
    $MeasureName = ConvertTo-CleanName -name $MeasureName
    $MeasureName = ConvertTo-SafeName -name $MeasureName


    # Mdx returns pivoted output... unpivot into new table to be equivalent to Sql output (columns: DimensionValue0, DimensionValue1, MeasureValue)
    $ColumnCount=$DataTable.Columns.Count
    # get column names for new table
    $AnchorColumnName = $DataTable.Columns[0].ColumnName.Split('.')[-2]
    $AnchorColumnName = ConvertTo-CleanName -name $AnchorColumnName
    $AnchorColumnName = ConvertTo-SafeName -name $AnchorColumnName
    $PivotColumnName = $DataTable.Columns[1].ColumnName.Split('.')[-2]
    $PivotColumnName = ConvertTo-CleanName -name $PivotColumnName
    $PivotColumnName = ConvertTo-SafeName -name $PivotColumnName

    
    # simplify mdx output; get dim column name: [DatabaseName].[DimTableName].[DimColumnName].[MdxSelection] -> [DimColumnName]
    $DataTable.Columns[0].ColumnName=$AnchorColumnName

    # create new DataTable object to hold pivoted version of Mdx output DataTable object
    [void]$DataSet.Tables.Add("$MeasureName")
    $NewTable = $DataSet.Tables["$MeasureName"]
    # add same three columns as expectedd from Sql (columns: DimensionValue0, DimensionValue1, MeasureValue) = ($PivotColumnName, $AnchorColumnName, $MeasureName)
    [void]$NewTable.Columns.Add($MeasureName)
    [void]$NewTable.Columns.Add($PivotColumnName)
    [void]$NewTable.Columns.Add($AnchorColumnName)

    # optionally set data type of measure column
    $NewTable.Columns["$MeasureName"].DataType = [string]
    $NewTable.Columns["$PivotColumnName"].DataType = [string]

    # extract pivot column names: [DatabaseName].[DimTableName].[DimColumnName].&[DimValue] -> [DimValue]
    # [All] is always first column; skip it
    # ***********   ASSUME: last column is Null and should be skipped *********************
    #foreach($i in 2..($ColumnCount-2))
    #{
        #$DataTable.Columns[$i].ColumnName=$DataTable.Columns[$i].ColumnName.Split('&')[1]
    #}
    
    # populate new pivoted DataTable
    # ***********   Perfomance: columns have less cardinality than rows *********************
    foreach($i in 2..($ColumnCount-2))
    {
        $DataTable.Columns[$i].ColumnName=$DataTable.Columns[$i].ColumnName.Split('&')[1]
    
        # populate new rows for this pivoted column
        $ColumnName=$DataTable.Columns[$i].ColumnName
        $rows = $DataTable | Select-Object -Property @{Name="$MeasureName"; Expression={$_."$ColumnName"}}, @{Name="$PivotColumnName"; Expression={"$ColumnName"}}, @{Name="$AnchorColumnName"; Expression={$_."$AnchorColumnName"}}
        foreach($row in $rows)
        {
            # Write-Output $row
            # skip null measure values
            if($row."$AnchorColumnName" -ne [DBNull]::Value)
            {
                # remove square brackets if they exist ([2015] -> 2015)
                $NoBracketPivotValue=($row."$PivotColumnName").Replace('[','').Replace(']','')
                [void]$NewTable.Rows.Add($row."$MeasureName",$NoBracketPivotValue,$row."$AnchorColumnName")
            }
        }
    }
   return, $DataSet.Tables["$MeasureName"]
}
# Export-ModuleMember -Function Invoke-UnitTestMdxQuery



# .\UtilityFunctions.ps1
<# 
.SYNOPSIS 
Executes sql query from sql script specified by UnitTestName.
.DESCRIPTION 
Executes sql query from sql script specified by UnitTestName.
Sql query should return 3 columns: Dimension0Name,Dimension1Name,MeasureName
The records should contain the values that correspond to the column names.
Creates a DataTable sql query from sql script specified by UnitTestName.
DataTable repersents the source of truth for a cube.
.INPUTS 
ServerName 
    Target Sql server that the query will be executed on.
UnitTestName 
    Standard name that follows naming convention: Cube--Measure--Column Dim--Row Dim
.OUTPUTS 
   System.Data.DataTable 
.EXAMPLE 
    figure it out
.NOTES 
    this is defineatly noteworthy
.LINK 
http://thepowershellguy.com/blogs/posh/archive/2007/01/21/powershell-gui-scripblock-monitor-script.aspx 
#> 
Function Invoke-UnitTestSqlQuery ($Server, $UnitTestName) {
    $ErrorActionPreference = "Stop"
    Write-Host ("Executing Sql for UnitTest: `n`t{0}" -f $UnitTestName)
    $SqlQuery = Get-UnitTestSqlQuery $UnitTestName
    
    # Use SqlClient API to execute Mdx query and populate generic DataSet.DataTable
	$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$SqlConnection.ConnectionString = "Server='$Server';Database='tempdb';trusted_connection=true;"
	$SqlConnection.Open()
	$Command = New-Object System.Data.SqlClient.SqlCommand
	$Command.Connection = $SqlConnection
    
	$Command.CommandText = $SqlQuery
    $Adapter = New-Object System.Data.SqlClient.SqlDataAdapter $Command
    $Dataset = New-Object System.Data.DataSet
    $Adapter.Fill($Dataset) | Out-Null
    $SqlConnection.Close()

    # standardize column names with [] wrap
    $TempColumnName=$DataSet.Tables[0].Columns[0].ColumnName
    $TempColumnName = ConvertTo-CleanName -Name $TempColumnName
    $TempColumnName = ConvertTo-SafeName -Name $TempColumnName
    $DataSet.Tables[0].Columns[0].ColumnName = $TempColumnName
    
    $TempColumnName=$DataSet.Tables[0].Columns[1].ColumnName
    $TempColumnName = ConvertTo-CleanName -Name $TempColumnName
    $TempColumnName = ConvertTo-SafeName -Name $TempColumnName
    $DataSet.Tables[0].Columns[1].ColumnName = $TempColumnName
    
    $TempColumnName=$DataSet.Tables[0].Columns[2].ColumnName
    $TempColumnName = ConvertTo-CleanName -Name $TempColumnName
    $TempColumnName = ConvertTo-SafeName -Name $TempColumnName
    $DataSet.Tables[0].Columns[2].ColumnName = $TempColumnName

    Write-Output $DataSet.Tables
}
# Export-ModuleMember -Function Invoke-UnitTestSqlQuery

#.\Invoke-SqlCubeUnitTest.ps1
#.\Invoke-MdxCubeUnitTest.ps1
#.\UtilityFunctions.ps1
Function Invoke-CubeUnitTest ($TestSqlServerName, $TestCubeServerName, $UnitTestName)
{
    $ErrorActionPreference = "Stop"
    Write-Host ("Executing UnitTest: `n`t{0}" -f $UnitTestName)
    
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
    $CubeName = ConvertTo-CleanName -Name $CubeName
    $Dimension0Name,$Dimension1Name = Get-UnitTestDimensionNames -UnitTestName $UnitTestName
    $MeasureName = Get-UnitTestMeasureName -UnitTestName $UnitTestName

    # get cube process date from Get-CubeProcessDate
    $CubeProcessDate = Get-CubeProcessDate -Server "$TestCubeServerName" -CubeName $CubeName

    # get outputs from Sql script
    $SqlOutput = Invoke-UnitTestSqlQuery -Server $TestSqlServerName -UnitTestName $UnitTestName

    try
    {
        # set Sql proc parameters for Sql UnitTest output
        $TestResultSource = $TestSqlServerName
        [void]$SqlCommand.Parameters.Add("@CubeName", [System.Data.SqlDbType]::String)
        $SqlCommand.Parameters["@CubeName"].Value = $CubeName
        [void]$SqlCommand.Parameters.Add("@CubeProcessDate", [System.Data.SqlDbType]::DateTime)
        $SqlCommand.Parameters["@CubeProcessDate"].Value = $CubeProcessDate
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
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Write-Host ("Error loading Sql query results: {0}`n{1}" -f $FailedItem, $ErrorMessage)
        #Write-Host $SqlOutput | Format-Table -AutoSize
        $SqlOutput
        # Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
        Break

    }
    # get Mdx output
    $MdxOutput = Invoke-UnitTestMdxQuery -Server $TestCubeServerName -UnitTestName $UnitTestName

    # execute proc with Mdx output
    $TestResultSource = $TestCubeServerName
    $SqlCommand.Parameters["@TestResultSource"].Value = $TestResultSource
    $SqlCommand.Parameters["@CubeUnitTestResults"].Value = $MdxOutput
    [void]$SqlCommand.ExecuteNonQuery()

    [void]$SqlConnection.Close()
}
# Export-ModuleMember -Function Invoke-CubeUnitTest

Set-Location -Path "C:\Users\gcrowell\Dropbox\Vault\Dev\CommunityMart\Cube\Tabular\ReferralEDVisitCube\testing"
$TestCubeServerName="STDSDB004\tabular"
$TestSqlServerName="STDBDECSUP01"
$UnitTestName="ReferralEDVisitCube--ED Visits--Fiscal Year--Chief Complaint System"
$UnitTestName="ReferralEDVisitCube--Active Referrals--Fiscal Year--Paris Team Name"

$CubeName = Get-UnitTestCubeName -UnitTestName $UnitTestName
$CubeName = ConvertTo-CleanName -Name $CubeName
# Get-CubeProcessDate -Server "$TestCubeServerName" -CubeName $CubeName
Invoke-CubeUnitTest -TestSqlServerName $TestSqlServerName -TestCubeServerName $TestCubeServerName -UnitTestName $UnitTestName