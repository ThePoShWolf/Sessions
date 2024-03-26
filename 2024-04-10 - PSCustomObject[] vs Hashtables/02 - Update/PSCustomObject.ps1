# Update property using dot notation
$obj.Location = 'Seattle, WA'
$obj

# Add property using Add-Member
$obj | Add-Member -MemberType NoteProperty -Name MilitaryTime -Value '0900'
$obj

# Add property using Add-Member with a hashtable
$obj | Add-Member -NotePropertyMembers @{
    TimeZone = 'PST'
    Time     = '9:00 AM'
}
$obj

# Add property using Add() method
$obj.PSObject.Properties.Add([PSNoteProperty]::new('Address', '123 Main st'))
$obj

# Remove property
$obj.PSObject.Properties.Remove('Address')
$obj

# Finding properties
$obj.PSObject.Properties.Name

# Testing for a property
$obj.PSObject.Properties.Name -contains 'Location'

# Accessing a property from a variable
$property = 'Location'
$obj.$property
$obj[$property]