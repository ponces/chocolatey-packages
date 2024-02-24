[CmdletBinding()]
param([switch]$Force)

Import-Module AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_AfterUpdate {
  $file = ".\tools\chocolateyInstall.ps1"
  (Get-Content -Path $file) | Set-Content -Encoding Ascii -Path $file
  Remove-Item -Path ".\tools\*.zip" -ErrorAction SilentlyContinue
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')"          = "`${1}'$($Latest.URL64)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`${1}'$($Latest.Checksum64)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`${1}'$($Latest.checksumType64)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseURL)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?<=URL64:\s*)((?<URL64>([^\s].+)))"           = "$($Latest.URL64)"
      "(?<=Type64:\s*)((?<Type64>([^\s].+)))"         = "$($Latest.ChecksumType64)"
      "(?<=Checksum64:\s*)((?<Checksum64>([^\s].+)))" = "$($Latest.Checksum64)"
    }
  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease facebook sapling

  return @{
    Version     = $LatestRelease.tag_name.TrimStart("v") -replace "\-.*", ""
    URL64       = $LatestRelease.assets | Where-Object {$_.name.StartsWith("sapling_windows_")} | Select-Object -ExpandProperty browser_download_url
    ReleaseURL  = $LatestRelease.html_url
  }
}

update -ChecksumFor none -Force:$Force
