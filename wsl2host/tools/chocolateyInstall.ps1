$packageName    = 'wsl2host'
$url            = 'https://github.com/shayne/go-wsl2-host/releases/download/v0.3.5/wsl2host.exe'
$checksum       = '619581883D5D58436BE954417EF4B9F12F0B89BE4F06C4D023556E64FEBE2094'
$checksumType   = 'sha256'
$validExitCodes = @(0)

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\wsl2host"

New-Item `
  -Path $binaryLocation `
  -ItemType Directory `
  -Force

Get-ChocolateyWebFile `
  -PackageName $packageName `
  -FileFullPath "$binaryLocation\wsl2host.exe" `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType $checksumType

Install-ChocolateyPath -PathToInstall $binaryLocation
