$SsasServerName = "STDSDB004"
$SsasDatabaseName = "EDMartCube"
$SsasCubePerspective = "Emergency"

$MeasureName = "Count - Cases"
$Dimension1Name = "Start Date Fiscal Year"
$Dimension2Name = "Chief Complaint System"

$Dimension1Mdx = "[Start Date].[Start Date Fiscal Year].[Fiscal Year]"
$Dimension2Mdx = "[Chief Complaint].[Chief Complaint].[System]"

$MdxQuery = "SELECT NON EMPTY { [Measures].[$MeasureName] } ON COLUMNS, 
NON EMPTY { ($Dimension1Mdx.ALLMEMBERS * $Dimension2Mdx.ALLMEMBERS ) } DIMENSION PROPERTIES MEMBER_CAPTION, MEMBER_UNIQUE_NAME ON ROWS 
FROM [$SsasCubePerspective] "

$MdxQuery
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.AnalysisServices.AdomdClient") | Out-Null
# Use ADOMD API to execute Mdx query and populate generic DataSet.DataTable
$SsasConnectionString="Data source=$SsasServerName;Provider=MSOLAP.5;Cube=Model;Initial catalog=$SsasDatabaseName;"
$SsasConnection = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdConnection($SsasConnectionString)
$SsasConnection.Open() | Out-Null
$SsasCommand = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdCommand($MdxQuery, $SsasConnection)
$DataAdapter = New-Object Microsoft.AnalysisServices.AdomdClient.AdomdDataAdapter($SsasCommand) 

$DataSet = New-Object System.Data.DataSet("MdxCubeQueryResults")
[void]$DataAdapter.Fill($DataSet)
[void]$SsasConnection.Close()

# only 1 table exists in DataSet
$DataTable=$DataSet.Tables[0]
$DataTable.Rows[0]
$x=$DataTable.Rows | Select-Object {$_.'[Measures].[Count - Cases]', $_.'[Chief Complaint].[Chief Complaint].[System].[MEMBER_CAPTION]', $_."$Dimension1Mdx.[MEMBER_CAPTION]"}
$x[0].'$_.''[Measures].[Count - Cases]'', $_.''[Chief Complaint].[Chief Complaint].[System].[MEMBER_CAPTION]'', $_."$Dimension1Mdx.[MEMBER_CAPTION]"'