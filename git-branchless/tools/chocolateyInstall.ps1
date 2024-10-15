$packageName    = 'git-branchless'
$url            = 'https://github.com/arxanas/git-branchless/releases/download/v0.10.0/git-branchless-v0.10.0-x86_64-pc-windows-msvc.zip'
$checksum       = '60EBE87ED18DD1B2C93C5094C9E7C9960590A97E452FA3EC03720C9C71B29452'
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
