# Other places you can use imported .NET types

# OutputType
Function Get-DiscordGuild {
    [OutputType([Discord.Rest.RestGuild], ParameterSetName = 'byId')]
    [OutputType([Discord.Rest.RestGuild[]], ParameterSetName = 'all')]
    param(<#...#>)
    <#...#>
}

# Parameter type
[Parameter(
    Mandatory,
    ParameterSetName = 'byObj'
)]
[ValidateNotNullOrEmpty()]
[Discord.Rest.RestGuild]$Guild