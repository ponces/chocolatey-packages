$packageName    = 'git-branchless'
$url            = 'https://github.com/arxanas/git-branchless/releases/download/v0.8.0/git-branchless-v0.8.0-x86_64-pc-windows-msvc.zip'
$checksum       = '6C3ABC939F22191E51AA767E9FECD1CAAC1FC4F6F53D9B4DE83E8B9FAE22BCBA'
$checksumType   = 'sha256'
$validExitCodes = @(0)

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\git-branchless"

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

Install-ChocolateyPath -PathToInstall $binaryLocation
