#CREDITS: https://github.com/majkinetor/au-packages/blob/master/Test-Sandbox.ps1
param($package)

while(!$package)
{
  [string]$package = Read-Host -Prompt "package name"
}

if(!(Test-Path $package))
{
  Write-Error "Package $package not found!"
  exit
}


# Check if Windows Sandbox is enabled
if (-Not (Test-Path "$env:windir\System32\WindowsSandbox.exe")) {
  Write-Error -Category NotInstalled -Message @'
Windows Sandbox does not seem to be available. Check the following URL for prerequisites and further details:
https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-sandbox/windows-sandbox-overview

You can run the following command in an elevated PowerShell for enabling Windows Sandbox:
Enable-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM'
'@ -ErrorAction Stop
}

$cwd = (Get-Item .).Name
$tempFolder = "sandbox-test"
$cwdInSandbox = "C:\Users\WDAGUtilityAccount\Desktop\$cwd"
$tempFolderInSandbox = "C:\Users\WDAGUtilityAccount\Desktop\$cwd\$tempFolder"

# Initialize Temp Folder
New-Item $tempFolder -ItemType Directory | Out-Null

# Create Bootstrap script
$bootstrapScriptContent = @"
cd ~\Desktop
Write-Host 'Installing Chocolatey'
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation
choco install $package -s $cwdInSandbox
"@

$bootstrapScript = "choco-install.ps1";
$bootstrapScriptContent | Out-File "$tempFolder\$bootstrapScript"

# Create wsb file

$sandboxTestWsbContent = @"
<Configuration>
  <MappedFolders>
    <MappedFolder><HostFolder>$pwd</HostFolder></MappedFolder>
  </MappedFolders>
  <LogonCommand>
  <Command>PowerShell Start-Process PowerShell -WorkingDirectory '$tempFolderInSandbox' -ArgumentList '-ExecutionPolicy Bypass -NoExit -File $bootstrapScript'</Command>
  </LogonCommand>
</Configuration>
"@
$sandboxTestWsbFileName = 'SandboxTest.wsb'
$sandboxTestWsbFile = Join-Path -Path $tempFolder -ChildPath $sandboxTestWsbFileName
$sandboxTestWsbContent | Out-File $sandboxTestWsbFile

Write-Host 'Starting Testing Sandbox'
Start-Process WindowsSandbox $SandboxTestWsbFile -Wait
Remove-Item $tempFolder -Recurse -Force