$toolsDir         = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation   = "$(Get-ToolsLocation)\cromite"
$appDataLocation  = "$env:LOCALAPPDATA\Chromium"
$shortcutLocation = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Cromite.lnk"

. $toolsDir\Uninstall-ChocolateyPath.ps1

Remove-Item `
  -Path $binaryLocation `
  -Recurse -Force `
  -ErrorAction Continue

Remove-Item `
  -Path $appDataLocation `
  -Recurse -Force `
  -ErrorAction Continue

Remove-Item `
  -Path $shortcutLocation `
  -ErrorAction Continue
