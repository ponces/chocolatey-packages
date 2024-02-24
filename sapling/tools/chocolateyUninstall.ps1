$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\sapling"

. $toolsDir\Uninstall-ChocolateyPath.ps1

Remove-Item `
  -Path $binaryLocation `
  -Recurse -Force

Uninstall-ChocolateyPath `
  -PathToUninstall $binaryLocation

if ($PROFILE -and (Test-Path $PROFILE)) {
  $oldProfile = @(Get-Content $PROFILE)
  $newProfile = @()
  foreach ($line in $oldProfile) {
    if ($line -like 'Set-Alias -Name sl*') {
      continue
    }
    $newProfile += $line
  }
  Set-Content -Path $PROFILE -Value $newProfile -Force
}
