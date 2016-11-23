#
# Get_CubeProcessDate.ps1
#

Function Get-CubeLastProcessedDate($ServerName, $CubeName)
{
    $DmvQuery = "SELECT LAST_SCHEMA_UPDATE FROM `$system.mdschema_cubes WHERE [CUBE_NAME] = 'Model' AND [CATALOG_NAME] = '$CubeName'"
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
    $Dataset.Tables[0].Rows[0].LAST_SCHEMA_UPDATE
}
$ServerName = "STDSDB004\tabular"
$CubeName   = 'ReferralEDVisitCube'
#$DmvCommand = "SELECT LAST_SCHEMA_UPDATE FROM `$system.mdschema_cubes WHERE [CUBE_NAME] = 'Model' AND [CATALOG_NAME] = '$CubeName'"
Get-CubeLastProcessedDate -ServerName $ServerName -CubeName $CubeName