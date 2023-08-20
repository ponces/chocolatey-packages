# AU Packages Template: https://github.com/majkinetor/au-packages-template
# Copy this file to update_vars.ps1 and set the variables there. Do not include it in the repository.

$Env:mail_user              = ''
$Env:mail_pass              = ''
$Env:mail_server            = 'smtp.gmail.com'
$Env:mail_port              = '587'
$Env:mail_enablessl         = 'true'

$Env:api_key                = ''          #Chocolatey api key
$Env:gist_id                = ''          #Specify your gist id or leave empty for anonymous gist
$Env:gist_id_test           = ''          #Specify your gist id for test runs or leave empty for anonymous gist
$Env:github_user_repo       = ''          #{github_user}/{repo}
$Env:github_api_key         = ''          #Github personal access token
$Env:github_gists_api_key   = ''          #Github personal access token with gists read/write permissions

$Env:au_Push                = 'false'     #Push to chocolatey
$Env:au_Force               = 'false'
$Env:au_NoCheckChocoVersion = 'false'

$Env:default_branch         = 'main'
$Env:force_git              = 'false'
$Env:force_gitReleases      = 'false'