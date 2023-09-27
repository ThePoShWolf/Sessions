# Creating an object using a .NET type

# Using a cmdlet

Get-Date
(Get-Date).GetType()

Get-Item '.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell'
(Get-Item '.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell').GetType()

(Get-Process)[0]
(Get-Process)[0].GetType()

Get-Command Get-Command
(Get-Command Get-Command).GetType()

# Using New-Object

New-Object -TypeName datetime -ArgumentList 2023, 10, 11

New-Object -TypeName System.IO.DirectoryInfo -ArgumentList '.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell'

New-Object -TypeName System.Diagnostics.Process

New-Object -TypeName System.Management.Automation.CommandInfo

# Using the constructor

[datetime]::new(2023, 10, 11)

[System.IO.DirectoryInfo]::new('.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell')

[System.Diagnostics.Process]::new()

[System.Management.Automation.CommandInfo]::new()

# How do we know if it has a constructor?

[datetime].GetConstructors().Name

[System.Management.Automation.CommandInfo].GetConstructors().Name

# If it has a constructor, how do we know what to pass to it?

[datetime]::new