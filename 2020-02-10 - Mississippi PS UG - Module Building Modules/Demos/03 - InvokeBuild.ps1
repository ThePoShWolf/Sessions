# Show the build file
code .\TestModule.Build.ps1

#region 
# Run a build
Invoke-Build -Task ModuleBuild

# Take a look at the results
Import-Module .\build\TestModule

Get-Command -Module TestModule

# Add a cmdlet
Copy-Item ..\Utilities\ActiveSessions\Get-ActiveSessions.ps1 -Destination .\src\public

# Rebuild
Invoke-Build -Task ModuleBuild

# Verify
Import-Module .\build\TestModule

#endregion