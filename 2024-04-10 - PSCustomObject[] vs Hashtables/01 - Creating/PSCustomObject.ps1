# Empty PSCustomObject
$obj = New-Object -TypeName PSObject
$obj

# Adding values (the hard way)
$obj | Add-Member -MemberType NoteProperty -Name Event -Value 'PowerShell Summit 2024'
$obj | Add-Member -MemberType NoteProperty -Name Date -Value '2024-04-10'
$obj | Add-Member -MemberType NoteProperty -Name Location -Value 'Bellevue, WA'
$obj

# The easy way with a hashtable
$obj = New-Object -TypeName PSObject -Property @{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$obj

# The easiest way
$obj = [pscustomobject]@{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$obj

# An array of PSCustomObjects
$objs = 2024..2030 | ForEach-Object {
    [pscustomobject]@{
        Event    = "PowerShell Summit $_"
        Date     = "$_-04-10"
        Location = 'Bellevue, WA'
    }
}

# Sorting
$objs | Sort-Object -Property Date

# Cleanup
Remove-Variable obj, objs