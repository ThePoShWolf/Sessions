# Input bindings are passed in via param block.
param($Monitor)

# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' property is 'true' when the current function invocation is later than scheduled.
if ($Monitor.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

#region keep chat bot warm
$uri = "https://$($env:WEBSITE_HOSTNAME)/api/HttpStart?code=$($env:FUNCTIONKEY)"
$headers = @{
    'Content-Type' = 'application/json'
}
Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $(@{
        type = 'warmup'
    } | ConvertTo-Json -Compress
)
#endregion

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
