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

# .NET type syntax

[Namespace.Type]::Method('parameters')

# Using the constructor

[datetime]::new(2023, 10, 11)

[System.IO.DirectoryInfo]::new('.\2023-10-11 - Pacific PSUG - .NET Object in PowerShell')

[System.Diagnostics.Process]::new()

[System.Management.Automation.CommandInfo]::new()

# How do we know if it has a constructor?

[datetime].GetType()

[datetime] | Get-Member

[datetime].GetConstructors().Name

[System.Management.Automation.CommandInfo].GetConstructors().Name

# If it has a constructor, how do we know what to pass to it? Or what it outputs?

[datetime]::new

<#

OverloadDefinitions
-------------------
datetime new(long ticks)
|------|    |----------|
 Output     Parameter(s)

datetime new(long ticks, System.DateTimeKind kind)
datetime new(int year, int month, int day)
datetime new(int year, int month, int day, System.Globalization.Calendar calendar)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar, System.DateTimeKind kind)
datetime new(int year, int month, int day, int hour, int minute, int second)
datetime new(int year, int month, int day, int hour, int minute, int second, System.DateTimeKind kind)
datetime new(int year, int month, int day, int hour, int minute, int second, System.Globalization.Calendar calendar)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, System.DateTimeKind kind)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, System.Globalization.Calendar calendar)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond, System.DateTimeKind kind)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond, System.Globalization.Calendar calendar)
datetime new(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond, System.Globalization.Calendar calendar, System.DateTimeKind kind)
#>

# Discovering other methods and properties:

[datetime]:: # tab, tab, tab, enter

[datetime].GetMethods() | Format-Table Name

[datetime]::Now

# Another method

[datetime]::DaysInMonth

[datetime]::DaysInMonth(2023, 10)


# Getting enum values

help Set-ExecutionPolicy -Parameter ExecutionPolicy 

[Microsoft.PowerShell.ExecutionPolicy]

[Microsoft.PowerShell.ExecutionPolicy]:: # tab, tab, tab

[Microsoft.PowerShell.ExecutionPolicy].GetEnumNames()