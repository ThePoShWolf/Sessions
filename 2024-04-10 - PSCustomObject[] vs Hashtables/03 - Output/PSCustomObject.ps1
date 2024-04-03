# Simple
$obj
$obj | Format-Table
$obj | Format-List

# Arrays
$objs
$objs | Format-List
$objs | Format-Table
$objs | Out-GridView

# Using Select-Object and a hash table to rename properties
$objs | Select-Object Event, @{Name = 'Date'; Expression = { [datetime]$_.Date } }, Location

# Output to various types
$objs | ConvertTo-Json | Out-File -FilePath .\output.json
$objs | Export-Csv -Path .\output.csv -NoTypeInformation

# Output formats
Get-Process | Select-Object -first 5
Get-Service | Select-Object -first 5

# Fancily add a type to a non-typed object
$obj.PSObject.TypeNames.Insert(0, 'MyType')
$obj