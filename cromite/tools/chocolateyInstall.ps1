$packageName      = 'cromite'
$url              = 'https://github.com/uazo/cromite/releases/download/v130.0.6723.59-00f5239a3c15b6c898b246664f654c19f25b9122/chrome-win.zip'
$checksum         = '072CD4B194069D371864D81DB97DF02F361508DA28520468B6FF1FD8B626B7EE'
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
