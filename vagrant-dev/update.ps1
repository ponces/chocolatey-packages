[CmdletBinding()]
param($IncludeStream, [switch]$Force)

Import-Module AU
Import-Module "$PSScriptRoot\..\_scripts\au_extensions.psm1"

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_AfterUpdate {
  $file = ".\tools\chocolateyInstall.ps1"
  (Get-Content -Path $file) | Set-Content -Encoding Ascii -Path $file
  Remove-Item -Path ".\tools\*.msi" -ErrorAction SilentlyContinue
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`${1}'$($Latest.URL32)'"
      "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`${1}'$($Latest.URL64)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\s*packageName\s*=\s*)('.*')"  = "`${1}'$($Latest.PackageName)'"
      "(?i)(^\s*softwareName\s*=\s*)('.*')" = "`${1}'$($Latest.PackageName)'"
      "(?i)(^\s*fileType\s*=\s*)('.*')"      = "`${1}'$($Latest.FileType)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseURL)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?<=URL32:\s*)((?<URL32>([^\s].+)))"           = "$($Latest.URL32)"
      "(?<=URL64:\s*)((?<URL64>([^\s].+)))"           = "$($Latest.URL64)"
      "(vagrant_(?=[^\s]+i686)[^\s]+\.msi)"           = "$($Latest.Filename32)"
      "(vagrant_(?=[^\s]+amd64)[^\s]+\.msi)"          = "$($Latest.Filename64)"
      "(?<=Type32:\s*)((?<Type32>([^\s].+)))"         = "$($Latest.ChecksumType32)"
      "(?<=Type64:\s*)((?<Type64>([^\s].+)))"         = "$($Latest.ChecksumType64)"
      "(?<=Checksum32:\s*)((?<Checksum32>([^\s].+)))" = "$($Latest.Checksum32)"
      "(?<=Checksum64:\s*)((?<Checksum64>([^\s].+)))" = "$($Latest.Checksum64)"
    }
  }
}

function global:au_GetLatest {
  $releases = Get-AllGithubReleases -Owner hashicorp -Name vagrant | Where-Object { $_.prerelease -match 'true' }

  $releases | Select-Object -First 1 | ForEach-Object {
    $version = $_.tag_name.TrimStart("v") -replace '\+', '' -replace '\-.*', '' -replace '\.dev', '-dev'

    $url32 = $_.assets | Where-Object browser_download_url -match '_windows_i686\.msi$' | Select-Object -ExpandProperty browser_download_url
    $url64 = $_.assets | Where-Object browser_download_url -match '_windows_amd64\.msi$' | Select-Object -ExpandProperty browser_download_url

    return @{
      Version     = $version
      URL32       = $url32
      URL64       = $url64
      ReleaseURL  = $_.html_url
    }
  }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
