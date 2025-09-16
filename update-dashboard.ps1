$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$templatePath = Join-Path $root 'index.html'
$vmCsvPath = Join-Path $root 'vmTable.csv'
$clusterJsonPath = Join-Path $root 'clusterInfo.json'
$outputPath = Join-Path $root 'Nutanix_HCI_Dashboard.html'

if (!(Test-Path $templatePath)) { throw "Template not found: $templatePath" }
if (!(Test-Path $vmCsvPath)) { throw "VM CSV not found: $vmCsvPath" }
if (!(Test-Path $clusterJsonPath)) { throw "Cluster JSON not found: $clusterJsonPath" }

$template = Get-Content $templatePath -Raw
$vmCsv = Get-Content $vmCsvPath -Raw
$clusterJson = Get-Content $clusterJsonPath -Raw

$vmContent = ($vmCsv.TrimEnd()) + "`n"
$clusterContent = $clusterJson.Trim()

if (-not $template.Contains('__VM_TABLE__')) { throw 'Template missing __VM_TABLE__ placeholder.' }
if (-not $template.Contains('__CLUSTER_JSON__')) { throw 'Template missing __CLUSTER_JSON__ placeholder.' }

$result = $template.Replace('__VM_TABLE__', $vmContent)
$result = $result.Replace('__CLUSTER_JSON__', $clusterContent)

Set-Content -Path $outputPath -Value $result -Encoding UTF8
