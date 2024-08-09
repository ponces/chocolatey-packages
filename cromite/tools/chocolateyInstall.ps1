$packageName      = 'cromite'
$url              = 'https://github.com/uazo/cromite/releases/download/v127.0.6533.103-667d85d6eb35d8e2fe27b1ed3091ce4714eab4c8/chrome-win.zip'
$checksum         = '8FBFBA679EB2CA1EC6412A8332C4601E920DCA7A7FB8DD1C42A13D72BC84E181'
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
