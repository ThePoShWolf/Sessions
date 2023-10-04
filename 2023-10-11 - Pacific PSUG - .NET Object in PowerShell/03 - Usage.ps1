# If you are using an established .NET library, start with their documentation!
# Discovery will only get you so far.
# We are going to do some demos with the Discord.NET SDK
# They have excellent docs, by the way

# Need to find the fully qualified type name for DiscordRestClient

[DiscordRestClient] # tab

# Completes to:

[Discord.Rest.DiscordRestClient]

# Examine the constructor

[Discord.Rest.DiscordRestClient]::new

# What is the DiscordRestConfig?

[Discord.Rest.DiscordRestConfig]::new

# Lets make one

$drc = [Discord.Rest.DiscordRestConfig]::new()
$drc

# Ok, probably don't need it. Lets make a client

$client = [Discord.Rest.DiscordRestClient]::new()
$client

# How to connect?

$client | Get-Member

# Lets try LoginAsync

$client.LoginAsync

<#

OverloadDefinitions
-------------------
System.Threading.Tasks.Task LoginAsync(Discord.TokenType tokenType, string token, bool validateToken = True)
|-------------------------| |--------| |----------------------------------------| |-----------------------|
 Output                      Method     Required parameters                        Params with default values
#>

# What is token type?

[Discord.TokenType]

# What are the values?

[Discord.TokenType].GetEnumNames()

# Lets log in

$task = $client.LoginAsync([Discord.TokenType]::Bot, (Get-Content C:\tmp\bottoken.txt))