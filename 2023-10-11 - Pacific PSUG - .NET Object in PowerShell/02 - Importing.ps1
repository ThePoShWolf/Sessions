# Very simple

Add-Type -Path "Fully qualified path to .dll"

# For example, if you had the Discord.NET .dlls:

Get-Item ..\Discordant\lib\*.dll | ForEach-Object {
    Add-Type $_.FullName
}

# Don't forget -Path

Get-Item ..\Discordant\lib\*.dll | ForEach-Object {
    Add-Type -Path $_.FullName
}

# If you are importing into a module, you can instead use RequiredAssemblies in the manifest
# Show Modrify build
# https://stackoverflow.com/a/72509967/75772

code ..\Modrify\build\Modrify\Modrify.psd1

# Both ways make the .NET types available to the shell, not just module cmdlets

# Finding types in a .dll
$assembly = [System.Reflection.Assembly]::LoadFrom('C:\temp\mytestlib.dll')
$assembly.GetTypes()