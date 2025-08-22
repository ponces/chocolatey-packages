$packageName      = 'cromite'
$url              = 'https://github.com/uazo/cromite/releases/download/v139.0.7258.143-8b0ce0bcfdca08fb2ebb937d31c80d68488343f8/chrome-win.zip'
$checksum         = 'FD290A704439CE5E1803D74C23366DD5E8E2E65DAEDBB898822F92623353F8D4'
$launcherChecksum = 'C698E8BAED23EE1AD9366B475F52436BBBE95BAEB3CA022E198A33865835CC99'
$checksumType     = 'sha256'
$validExitCodes   = @(0)

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\cromite"
$shortcutLocation = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Cromite.lnk"

New-Item `
  -Path $binaryLocation `
  -ItemType Directory `
  -Force

Install-ChocolateyZipPackage `
  -PackageName $packageName `
  -Url64bit $url `
  -UnzipLocation $binaryLocation `
  -Checksum64 $checksum `
  -ChecksumType64 $checksumType

Copy-Item `
    -Path "$binaryLocation\chrome-win\*" `
    -Destination "$binaryLocation" `
    -Recurse -Force

Remove-Item `
  -Path "$binaryLocation\chrome-win" `
  -Recurse -Force `
  -ErrorAction Continue

icacls $binaryLocation /grant "*S-1-15-2-2:(OI)(CI)(RX)" /Q

Install-ChocolateyShortcut `
  -ShortcutFilePath $shortcutLocation `
  -TargetPath "$binaryLocation\chrome.exe" `
  -IconLocation "$binaryLocation\chrome.exe"
