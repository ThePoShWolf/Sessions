# Empty hashtable
$ht = New-Object -TypeName hashtable
$ht

# Adding values
$ht.Add('Event', 'PowerShell Summit 2024')
$ht.Add('Date', '2024-04-10')
$ht.Add('Location', 'Bellevue, WA')
$ht

# Easy way
$ht = @{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$ht

# Sorting
$ht | Sort-Object -Property Name
$ht.GetEnumerator() | Sort-Object -Property Name

# Ordered
$ht = [ordered]@{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$ht

# Cleanup
Remove-Variable ht