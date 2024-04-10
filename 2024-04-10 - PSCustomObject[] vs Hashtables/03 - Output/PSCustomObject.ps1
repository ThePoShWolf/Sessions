# Simple
$obj
$obj | Format-Table
$obj | Format-List

# Arrays
$objs
$objs | Format-List
$objs | Format-Table

# Using Select-Object and a hash table to rename properties
$objs | Select-Object Event, @{Name = 'Date'; Expression = { [datetime]$_.Date } }, Location

# Output to various types
$objs | ConvertTo-Json | Out-File -FilePath .\output.json
$objs | Export-Csv -Path .\output.csv -NoTypeInformation

# Output formats
Get-Process | Select-Object -first 2
Get-Service | Select-Object -first 2

# Fancily add a type to a non-typed object
Update-FormatData -AppendPath '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\03 - Output\SampleView.ps1xml'
$obj.PSObject.TypeNames.Insert(0, 'MyType')
$obj

# Convert to hashtable
$hashtable = @{}
foreach ( $prop in $obj.PSObject.Properties.Name ) {
    $hashtable[$prop] = $obj.$prop
}
$hashtable