$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\wsl2host"

. $toolsDir\Uninstall-ChocolateyPath.ps1

Remove-Item `
    -Path $binaryLocation `
    -Recurse -Force

Uninstall-ChocolateyPath `
    -PathToUninstall $binaryLocation
