$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'vagrant-dev'
  fileType        = 'msi'
  url            = 'https://github.com/hashicorp/vagrant/releases/download/2.4.2.dev%2B000182-d8fdc500/vagrant_2.4.2.dev_windows_i686.msi'
  url64bit       = 'https://github.com/hashicorp/vagrant/releases/download/2.4.2.dev%2B000182-d8fdc500/vagrant_2.4.2.dev_windows_amd64.msi'
  checksum       = '0BA6BF2B746CF90073946E76FA67D0A9BD67BA3FB2FD2B36F39866534E4BE3DD'
  checksum64     = 'FA18B3A6E94886575CCC2AD558AFCAE5C33C783AD53958EAC4EC3D6287F869B3'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  silentArgs     = "/qn /norestart"
  validExitCodes = @(0, 3010, 1641)
  softwareName   = 'vagrant-dev'
}
Install-ChocolateyPackage @packageArgs

Update-SessionEnvironment

$ErrorActionPreference = 'Continue' #https://github.com/chocolatey/chocolatey-coreteampackages/issues/1099

#https://github.com/chocolatey/chocolatey-coreteampackages/issues/1358
$proxy = Get-EffectiveProxy
if ($proxy) {
  Write-Host "Setting CLI proxy: $proxy"
  $env:http_proxy = $env:https_proxy = $proxy
}
vagrant plugin update

vagrant plugin repair               #https://github.com/chocolatey/chocolatey-coreteampackages/issues/1024
if ($LastExitCode -ne 0) {          #https://github.com/chocolatey/chocolatey-coreteampackages/issues/1099
  Write-Host "WARNING: Plugin repair failed, run 'vagrant plugin expunge --reinstall' after rebooting."
  $LastExitCode = 0
}
