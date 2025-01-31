$packageName      = 'cromite'
$url              = 'https://github.com/uazo/cromite/releases/download/v132.0.6834.163-ae296a42b9b1412a54aca8635affabd26ea8ce1e/chrome-win.zip'
$checksum         = '9524D1AEC189A5C1B2C954695DF9A05B4B4B8F16402B7FE578E8F4BA1C053B2B'
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
