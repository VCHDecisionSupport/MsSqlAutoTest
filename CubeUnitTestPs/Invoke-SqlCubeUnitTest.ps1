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
    Write-Host ("Executing Sql for UnitTest: {0}" -f $UnitTestName)
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


