# Update key using hashtable notation
$ht['Location'] = 'Redmond, WA'
$ht

# Update key using dot notation
$ht.Location = 'Eugene, OR'
$ht

# Add key using hashtable notation
$ht['MilitaryTime'] = '0900'
$ht

# Add key using dot notation
$ht.Time = '9:00 AM'
$ht

# Add key using Add method
$ht.Add('TimeZone', 'PST')
$ht

# Remove key
$ht.Remove('TimeZone')
$ht

# Finding key
$ht.Keys

# Testing for a key
$ht.ContainsKey('Location')
$ht.Contains('Location')
$ht.Keys -contains 'Location'

# Which is more efficient?
[PSCustomObject]@{
    ContainsKey = Measure-Command {
        foreach ($x in 1..100000) {
            $ht.ContainsKey('Location')
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
    Contains    = Measure-Command {
        foreach ($x in 1..100000) {
            $ht.Contains('Location')
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
    '-Contains' = Measure-Command {
        foreach ($x in 1..100000) {
            $ht.Keys -contains 'Location'
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
}

# Accessing a key from a variable
$property = 'Location'
$ht.$property
$ht[$property]