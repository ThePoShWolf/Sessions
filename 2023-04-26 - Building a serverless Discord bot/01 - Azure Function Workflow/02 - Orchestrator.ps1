using namespace System.Net

# Ensure this matches the bindings in function.json
param($Request, $TriggerMetadata)

$Body = $Request.Body

# remove color from output for easier reading in colorless terminals
$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText

# switch on the command name
switch ($Body.data.name) {
    # simple command
    'hello' {
        Write-Host 'hello command...'
        $content = "Hello $($Body.member.user.username)"
    }
    # example with parameters
    'start-server' {
        Write-Host 'start-server command...'
        if ($Body.data.keys -contains 'options') {
            $server = $Body.data['options'][0].value
            # code to start server...
            $content = "Started server '$server'"
        } else {
            $content = "Please specify a server with the server parameter."
        }
    }
    default {
        Write-Host "Unknown command: '$($Body.data.name)'"
    }
}
if (-not ($content.Length -gt 0)) {
    $content = 'failure'
}
Write-Host $content

# send response to discord
Send-DiscordFollowup -RequestBody $Body -Content $content

# pushing the response to the output binding
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = 'ok'
    }
)

Write-Host 'End command'