# Update property using hashtable notation
$ht['Location'] = 'Redmond, WA'
$ht

# Update property using dot notation
$ht.Location = 'Seattle, WA'
$ht

# Add property using hashtable notation
$ht['MilitaryTime'] = '0900'
$ht

# Add property using dot notation
$ht.Time = '9:00 AM'
$ht

# Add property using Add method
$ht.Add('TimeZone', 'PST')
$ht

# Remove property
$ht.Remove('TimeZone')
$ht

# Finding properties
$ht.Keys

# Testing for a property
$ht.Contains('Location')
$ht.Keys -contains 'Location'

# Which is more efficient?
Measure-Command {
    0..10000 | ForEach-Object { $ht.Contains('Location') }
}
Measure-Command {
    0..10000 | ForEach-Object { $ht.Keys -contains 'Location' }
}

# Accessing a property from a variable
$property = 'Location'
$ht.$property
$ht[$property]