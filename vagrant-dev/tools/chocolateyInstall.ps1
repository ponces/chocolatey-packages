$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'vagrant-dev'
  fileType        = 'msi'
  url            = 'https://github.com/hashicorp/vagrant/releases/download/2.3.8.dev%2B000111-34092d97/vagrant_2.3.8.dev_windows_i686.msi'
  url64bit       = 'https://github.com/hashicorp/vagrant/releases/download/2.3.8.dev%2B000111-34092d97/vagrant_2.3.8.dev_windows_amd64.msi'
  checksum       = 'A510AD796D0E7E385362D0E2F579BCD14B4A62D5D0C50B7A046C483B8694B0F6'
  checksum64     = 'AE9CB162846E28F17F9C721BF451F9C3458EB358F420E45D3E0590BFDD53E934'
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
