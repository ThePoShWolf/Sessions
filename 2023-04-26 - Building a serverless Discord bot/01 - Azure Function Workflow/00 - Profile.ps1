Import-Module /home/site/wwwroot/Modules/Discord.Net.PowerShell

Function Send-DiscordFollowup {
    [cmdletbinding()]
    param (
        [psobject]$RequestBody,
        [string]$Content
    )
    $splat = @{
        Uri         = "https://discord.com/api/v8/webhooks/$($RequestBody.application_id)/$($RequestBody.token)/messages/@original"
        Method      = 'Patch'
        ContentType = 'application/json'
        Body        = (
            @{
                type    = 4
                content = $Content
            } | ConvertTo-Json
        )
    }
    Invoke-RestMethod @splat
}