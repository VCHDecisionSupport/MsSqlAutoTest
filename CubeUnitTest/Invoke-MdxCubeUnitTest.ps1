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
    $MdxQuery = Get-UnitTestMdxQuery -UnitTestName $UnitTestName
    $CubeName = Get-UnitTestCubeName -UnitTestName $UnitTestName
    $CubeName = ConvertTo-CleanName -name $CubeName

    # Use ADOMD API to execute Mdx query and populate generic DataSet.DataTable
    $SsasConnectionString="Data source=$ServerName\tabular;Provider=MSOLAP.5;Cube=Model;Initial catalog=$CubeName;"
    $SsasConnection = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($SsasConnectionString)
    $SsasConnection.Open() | Out-Null
    $SsasCommand = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdCommand($MdxQuery, $SsasConnection)
    $DataAdapter = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdDataAdapter($SsasCommand) 

    $DataSet = New-Object System.Data.DataSet("sadf")
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
    [void]$NewTable.Columns.Add($PivotColumnName)
    [void]$NewTable.Columns.Add($AnchorColumnName)
    [void]$NewTable.Columns.Add($MeasureName)

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
        $rows = $DataTable | Select-Object -Property @{Name="$PivotColumnName"; Expression={"$ColumnName"}}, @{Name="$AnchorColumnName"; Expression={$_."$AnchorColumnName"}}, @{Name="$MeasureName"; Expression={$_."$ColumnName"}}
        foreach($row in $rows)
        {
            # Write-Output $row
            # skip null measure values
            if($row."$AnchorColumnName" -ne [DBNull]::Value)
            {
                # remove square brackets if they exist ([2015] -> 2015)
                $NoBracketValue=($row."$PivotColumnName").Replace('[','').Replace(']','')
                [void]$NewTable.Rows.Add($NoBracketValue,$row."$AnchorColumnName",$row."$MeasureName")
            }
        }
    }
   return, $DataSet.Tables["$MeasureName"]
}
# Export-ModuleMember -Function Invoke-UnitTestMdxQuery

