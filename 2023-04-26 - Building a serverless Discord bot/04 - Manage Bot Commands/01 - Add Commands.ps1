# Auth to discord using bot token
Connect-Discord -RestClient -TokenType Bot -Token (Get-Content C:\tmp\bt.txt)

# Get the guild where you want the commands
$guild = Get-DiscordGuild | Where-Object { $_.Name -eq 'Bot Testing' }
$guild

# Add a basic command
New-DiscordGuildCommand -Name 'hello' -Description "Say hello to the bot" -Guild $guild -CommandBuilder (
    New-DiscordSlashCommand -Name 'hello' -Description 'Say Hello to the bot'
)

New-DiscordGuildCommand -Name 'bye' -Description "Say hello to the bot" -Guild $guild -CommandBuilder (
    New-DiscordSlashCommand -Name 'by' -Description 'Say Hello to the bot'
)

# Add a command with parameters
New-DiscordGuildCommand -Name 'start-server' -Description 'Start a server' -Guild $guild -CommandBuilder (
    New-DiscordSlashCommand -Name 'start-server' -Description 'Start a server' -Options @(
        (New-DiscordSlashCommandOption -Name 'server' -Description 'The selected server' -Type String)
    )
)

# Send a command to a channel
$channel = Get-DiscordChannel | Where-Object { $_.Name -eq 'general' }
Send-DiscordMessage -GuildId $guild.Id -ChannelId $channel.Id -MessageText 'Hello!'