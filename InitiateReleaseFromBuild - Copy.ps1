param(
 [string]$rmserver = $Args[0],
[string]$port = $Args[1],  
[string]$teamProject = $Args[2],   
 [string]$targetStageName = $Args[3], 
[string]$rmusername = $Args[4],
[string]$rmpassword = $Args[5],
[string]$rmdomain = $Args[6],
[string]$teamFoundationServerUrl = $Args[7],
[string]$buildDefinition = $Args[8],
[string]$buildNumber = $Args[9]
    )

Write-Host "teamFoundationServerUrl $teamFoundationServerUrl"
Write-Host "buildDefinition $buildDefinition"
Write-Host "buildNumber $buildNumber"


if(-not([string]::IsNullOrEmpty($env:TF_BUILD_COLLECTIONURI))) { 
    Write-Host "Setting Build Collection URI to: $env:TF_BUILD_COLLECTIONURI"
    Set-Variable -Name teamFoundationServerUrl -Value $env:TF_BUILD_COLLECTIONURI
}

if(-not([string]::IsNullOrEmpty($env:TF_BUILD_BUILDDEFINITIONNAME))) { 
    
    Write-Host "Setting buildDefinition to: $env:TF_BUILD_BUILDDEFINITIONNAME"
    Set-Variable -Name buildDefinition -Value $env:TF_BUILD_BUILDDEFINITIONNAME
    
}

if(-not([string]::IsNullOrEmpty($env:TF_BUILD_BUILDNUMBER))) { 
    
    Write-Host "Setting buildNumber to: $env:TF_BUILD_BUILDNUMBER"
    Set-Variable -Name buildNumber -Value $env:TF_BUILD_BUILDNUMBER
    
}


"Executing with the following parameters:`n"
"  RMserver Name: $rmserver"
"  Port number: $port"
"  Team Foundation Server URL: $teamFoundationServerUrl"
"  Team Project: $teamProject"
"  Build Definition: $buildDefinition"
"  Build Number: $buildNumber"
"  Target Stage Name: $targetStageName`n"

$exitCode = 0

trap
{
  $e = $error[0].Exception
  $e.Message
  $e.StackTrace
  if ($exitCode -eq 0) { $exitCode = 1 }
}

$scriptName = $MyInvocation.MyCommand.Name
$scriptPath = Split-Path -Parent (Get-Variable MyInvocation -Scope Script).Value.MyCommand.Path

Push-Location $scriptPath    

$server = [System.Uri]::EscapeDataString($teamFoundationServerUrl)
$project = [System.Uri]::EscapeDataString($teamProject)
$definition = [System.Uri]::EscapeDataString($buildDefinition)
$build = [System.Uri]::EscapeDataString($buildNumber)
$targetStage = [System.Uri]::EscapeDataString($targetStageName)

$serverName = $rmserver + ":" + $port
$orchestratorService = "http://$serverName/account/releaseManagementService/_apis/releaseManagement/OrchestratorService"

$status = @{
    "2" = "InProgress";
    "3" = "Released";
    "4" = "Stopped";
    "5" = "Rejected";
    "6" = "Abandoned";
}

$uri = "$orchestratorService/InitiateReleaseFromBuild?teamFoundationServerUrl=$server&teamProject=$project&buildDefinition=$definition&buildNumber=$build&targetStageName=$targetStage"
"Executing the following API call:`n`n$uri"

$wc = New-Object System.Net.WebClient
#$wc.UseDefaultCredentials = $true
# rmuser should be part rm users list and he should have permission to trigger the release.

$wc.Credentials = new-object System.Net.NetworkCredential($rmusername, $rmpassword, $rmdomain)

try
{
    $releaseId = $wc.DownloadString($uri)

    $url = "$orchestratorService/ReleaseStatus?releaseId=$releaseId"

    $releaseStatus = $wc.DownloadString($url)

    Write-Host -NoNewline "`nReleasing ..."

    while($status[$releaseStatus] -eq "InProgress")
    {
        Start-Sleep -s 5
        $releaseStatus = $wc.DownloadString($url)
        Write-Host -NoNewline "."
    }

    " done.`n`nRelease completed with {0} status." -f $status[$releaseStatus]
}
catch [System.Exception]
{
    if ($exitCode -eq 0) { $exitCode = 1 }
    Write-Host "`n$_`n" -ForegroundColor Red
}

if ($exitCode -eq 0)
{
  "`nThe script completed successfully.`n"
}
else
{
  $err = "Exiting with error: " + $exitCode + "`n"
  Write-Host $err -ForegroundColor Red
}

Pop-Location

exit $exitCode
