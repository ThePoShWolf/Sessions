# Auth to discord using bot token
Connect-Discord -RestClient -TokenType Bot -Token 'insert bot token here'

# Get the guild where you want the commands
$guild = Get-DiscordGuild | Where-Object { $_.Name -eq 'Bot Testing' }

# Add a basic command
New-DiscordGuildCommand -Name 'hello' -Description "Say hello to the bot" -Guild $guild -CommandBuilder (
    New-DiscordSlashCommand -Name 'hello' -Description 'Say Hello to the bot'
)

# Add a command with parameters
New-DiscordGuildCommand -Name 'start-server' -Description 'Start a server' -Guild $guild -CommandBuilder (
    New-DiscordSlashCommand -Name 'start-server' -Description 'Start a server' -Options @(
        (New-DiscordSlashCommandOption -Name 'server' -Description 'The selected server' -Type String)
    )
)