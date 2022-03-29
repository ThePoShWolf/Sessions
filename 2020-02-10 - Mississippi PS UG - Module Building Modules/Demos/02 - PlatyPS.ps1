# Demonstrate code

#region Create the markdown files
# Import the module
Import-Module .\build\TestModule

# Review the cmdlets
Get-Command -Module TestModule

# Review the help
Help Get-InstalledSoftware
Help Format-Bytes

# Create the markdown help
New-MarkdownHelp -Module TestModule -OutputFolder .\docs

# Output the markdown help to an external PS help xml
# This should go in your build script! (to be demonstrated)
New-ExternalHelp .\docs -OutputPath ".\build\TestModule\EN-US"

#endregion