cd $PSScriptRoot
$src_file = 'TableSummary.rdl'
$src_path = $PSScriptRoot+"\{0}"-f $src_file
Write-Host $src_path
$release_path = "\\vchdfsp04\Departments\QUIST\Production\GrahamCrowell\SSRS_TableSummary\{0}" -f $src_file
Copy-Item -Path $src_path -Destination $release_path


cd $PSScriptRoot
$src_file = 'ColumnHistogram.rdl'
$src_path = $PSScriptRoot+"\{0}"-f $src_file
Write-Host $src_path
$release_path = "\\vchdfsp04\Departments\QUIST\Production\GrahamCrowell\SSRS_TableSummary\{0}" -f $src_file
Copy-Item -Path $src_path -Destination $release_path


# & \\vchdfsp04\Departments\QUIST\Production\GrahamCrowell\SSRS_TableSummary\update_custom_reports.ps1
