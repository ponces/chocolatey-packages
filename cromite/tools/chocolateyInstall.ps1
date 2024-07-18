$packageName      = 'cromite'
$launcherName     = 'chrlauncher'
$url              = 'https://github.com/uazo/cromite/releases/download/v127.0.6533.73-2f4346471b5f65ad4d4d3f62bfc26dda5203d1b2/chrome-win.zip'
$launcherUrl      = 'https://github.com/henrypp/chrlauncher/releases/download/v.2.6/chrlauncher-2.6-bin.zip'
$checksum         = 'E0A5E2938548B0774748F5BF58B4BA5219D66BFA142AFFD313965D21E8A1CE41'
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

Install-ChocolateyZipPackage `
  -PackageName $launcherName `
  -Url $launcherUrl `
  -UnzipLocation $binaryLocation `
  -Checksum $launcherChecksum `
  -ChecksumType $checksumType

Copy-Item `
  -Path "$binaryLocation\$launcherName\64\*" `
  -Destination $binaryLocation `
  -Recurse -Force

Remove-Item `
  -Path "$binaryLocation\$launcherName" `
  -Recurse -Force `
  -ErrorAction Continue

Copy-Item `
  -Path "$toolsDir\$launcherName.ini" `
  -Destination $binaryLocation `
  -Recurse -Force

Install-ChocolateyShortcut `
  -ShortcutFilePath $shortcutLocation `
  -TargetPath "$binaryLocation\$launcherName.exe" `
  -IconLocation "$binaryLocation\chrome.exe"
