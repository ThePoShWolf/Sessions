# Simple
$obj
$obj | Format-Table
$obj | Format-List

# Arrays
$objs
$objs | Format-List
$objs | Format-Table

# Output to various types
$objs | ConvertTo-Json | Out-File -FilePath .\output.json
$objs | Export-Csv -Path .\output.csv -NoTypeInformation

# add note about formats and types