# Replace with your GitHub personal access token
$token = "your_personal_access_token"
$owner = "your_organization"
$repo = "your_repository"
$run_id = 123456789  # Replace with the workflow run ID

# Function to fetch the logs URL
function Get-WorkflowLogsUrl {
    param(
        [string]$token,
        [string]$owner,
        [string]$repo,
        [int]$run_id
    )

    $headers = @{
        "Authorization" = "Bearer $token"
        "Accept" = "application/vnd.github+json"
    }

    $url = "https://api.github.com/repos/$owner/$repo/actions/runs/$run_id"
    $response = Invoke-WebRequest -Uri $url -Headers $headers
    $content = $response.Content | ConvertFrom-Json

    return $content.logs_url
}

# Function to download logs
function Download-WorkflowLogs {
    param(
        [string]$logsUrl,
        [string]$outputPath
    )

    $headers = @{
        "Authorization" = "Bearer $token"
    }

    Invoke-WebRequest -Uri $logsUrl -Headers $headers -OutFile $outputPath
}

# Get the logs URL
$logsUrl = Get-WorkflowLogsUrl -token $token -owner $owner -repo $repo -run_id $run_id

# Download the logs to a zip file
Download-WorkflowLogs -logsUrl $logsUrl -outputPath "workflow_logs.zip"
