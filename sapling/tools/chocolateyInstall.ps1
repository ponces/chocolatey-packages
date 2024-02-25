$packageName    = 'sapling'
$url            = 'https://github.com/facebook/sapling/releases/download/0.2.20240219-172743%2B3e819974/sapling_windows_0.2.20240219-172743%2B3e819974_amd64.zip'
$checksum       = '80B7756EF5C59F559091B78FA59B341536D4BA6486D14ECE54A50F363275F4B0'
$checksumType   = 'sha256'
$validExitCodes = @(0)

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$binaryLocation = "$(Get-ToolsLocation)\sapling"

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

Move-Item `
  -Path "$binaryLocation\Sapling\*" `
  -Destination $binaryLocation

Remove-Item `
  -Path "$binaryLocation\Sapling" `
  -Recurse -Force

Install-ChocolateyPath `
  -PathToInstall $binaryLocation

if (-not (Test-Path $PROFILE)) {
  New-Item $PROFILE -Type File -ErrorAction Stop -Force | Out-Null
}

if (-not (Get-Content $PROFILE | Select-String -Pattern 'Set-Alias -Name sl')) {
  Add-Content `
    -Path $PROFILE `
    -Value "Set-Alias -Name sl -Value ""$binaryLocation\sl.exe"" -Force -Option Constant,ReadOnly,AllScope"
}
