$packageName    = 'git-branchless'
$url            = 'https://github.com/arxanas/git-branchless/releases/download/v0.9.0/git-branchless-v0.9.0-x86_64-pc-windows-msvc.zip'
$checksum       = '90B4514274D59A602483253F788EAA25096EBE9B416F78227FD3D46468E2CD2B'
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
