# Empty PSObject
$obj = New-Object -TypeName PSObject
$obj

# Adding values (the hard way)
$obj | Add-Member -MemberType NoteProperty -Name Event -Value 'PowerShell Summit 2026'
$obj | Add-Member -MemberType NoteProperty -Name Date -Value '2026-04-14'
$obj | Add-Member -MemberType NoteProperty -Name Location -Value 'Bellevue, WA'
$obj

# The easy way with a hashtable
$obj = New-Object -TypeName PSObject -Property @{
    Event    = 'PowerShell Summit 2026'
    Date     = '2026-04-14'
    Location = 'Bellevue, WA'
}
$obj

# The easiest way
$obj = [pscustomobject]@{
    Event    = 'PowerShell Summit 2026'
    Date     = '2026-04-14'
    Location = 'Bellevue, WA'
}
$obj

# Or even inline
$obj = [pscustomobject]@{ Event = 'PowerShell Summit 2026'; Date = '2026-04-14'; Location = 'Bellevue, WA' }
$obj

# An array of PSCustomObjects
$objs = 2026..2031 | ForEach-Object {
    [pscustomobject]@{
        Event    = "PowerShell Summit $_"
        Date     = "$_-04-14"
        Location = 'Bellevue, WA'
    }
}
$objs

# Sorting
$objs | Sort-Object -Property Date -Descending

# Nested properties
$nestedObj = [pscustomobject]@{
    Event    = 'PowerShell Summit 2026'
    Date     = [pscustomobject]@{
        Year  = 2026
        Month = 4
        Day   = 14
    }
    Location = [pscustomobject]@{
        City  = 'Bellevue'
        State = 'WA'
    }
}
$nestedObj

# From JSON
$data = Get-Content '.\MOCK_DATA.json' | ConvertFrom-Json
$data[0]

# Faster than hashtables?
# Hashtable
Measure-Command { 
    1..10 | ForEach-Object { Get-Content '.\MOCK_DATA.json' | ConvertFrom-Json -AsHashtable }
} | Select-Object TotalMilliseconds
# PSCustomObject
Measure-Command {
    1..10 | ForEach-Object { Get-Content '.\MOCK_DATA.json' | ConvertFrom-Json }
} | Select-Object TotalMilliseconds