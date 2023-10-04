# Very simple

Add-Type -Path "Fully qualified path to .dll"

# For example, if you had the Discord.NET .dlls:

Get-Item ..\Discordant\lib\*.dll | ForEach-Object {
    Add-Type -Path $_.FullName
}

# If you are importing into a module, you can instead use RequiredAssemblies in the manifest
# Show Modrify build

code ..\Modrify\build\Modrify

# Both ways make the .NET types available to the shell, not just module cmdlets