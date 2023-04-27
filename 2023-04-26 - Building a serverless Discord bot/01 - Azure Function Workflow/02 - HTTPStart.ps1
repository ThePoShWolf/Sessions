using namespace System.Net

# Ensure this matches the bindings in function.json
param($Request, $TriggerMetadata)

# check for monitor call
if ($Request.Body.type -eq 'warmup') {
    $response = 'Warmed up'
} else {

    # First ensure that the request has the correct data
    if (
        [string]::IsNullOrEmpty($env:DISCORD_PUBLIC_KEY) -or `
            [string]::IsNullOrEmpty($Request.Headers.'x-signature-ed25519') -or `
            [string]::IsNullOrEmpty($Request.Headers.'x-signature-timestamp') -or `
            [string]::IsNullOrEmpty($Request.RawBody)
    ) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::Unauthorized
            }
        )
        Throw 'Invalid authentication context.'
    }

    # Then validate the signature using the Discord.Net.PowerShell Module
    $intSplat = @{
        PublicKey = $env:DISCORD_PUBLIC_KEY
        Signature = $Request.Headers.'x-signature-ed25519'
        TimeStamp = $Request.Headers.'x-signature-timestamp'
        Body      = $Request.RawBody
    }
    # Test-DiscordInteraction comes from Discord.NET.PowerShell
    # Make sure that is in your requirements.psd1
    if (-not (Test-DiscordInteraction @intSplat)) {
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::Unauthorized
            }
        )
        throw
    }

    # If request type is ping, ack it with type 1
    if ($Request.Body.type -eq 1) {
        $response = @{
            type = 1
        }
        Write-Host "ACKing ping"
    } elseif ($Request.Body.type -eq 2) {
        # If request type is 2, defer it with type 5
        # This must happen within 3 seconds
        Write-Host 'Type 2, submitting to queue and deferring...'
        $response = @{
            type    = 5
            content = "Pending"
        }

        # Submit the request to the orchestrator function
        # Times out after 1 second to finish within 3s for Discord
        $irmSplat = @{
            Uri        = "https://$($env:WEBSITE_HOSTNAME)/api/orchestrator?code=$($env:FUNCTIONKEY)"
            Method     = 'Post'
            Body       = ($Request.Body | ConvertTo-Json -Depth 10)
            Headers    = @{
                'Content-Type' = 'application/json'
                Accept         = 'application/json'
            }
            # This timeout value ensures that we can defer within 3s
            TimeoutSec = 1
        }

        # Since timing out generates an error, we'll try/catch it with no catch since it doesn't matter
        try {
            Invoke-RestMethod @irmSplat
        } catch {}
    }
}

# Push the output binding
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $response
    }
)