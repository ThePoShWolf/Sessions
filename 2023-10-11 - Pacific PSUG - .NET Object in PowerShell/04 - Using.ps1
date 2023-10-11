# Using using allows us to simplify type usage
# C# example: https://github.com/discord-net/Discord.Net/blob/dev/src/Discord.Net.Rest/BaseDiscordClient.cs
using namespace System.IO
using namespace Discord.Rest

# so instead of:
[System.IO.DirectoryInfo]::new('.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell')

# we can use:
[DirectoryInfo]::new('.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell')

#Link: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-7.3

# Discord example
[DiscordRestClient]::new()