# Select multiple keys
$ht['Event', 'Location']

# But doesn't really look great with an array of hashtables
$arrayOfHts

# Even with formatters
$arrayOfHts | Format-List
$arrayOfHts | Format-Table

# JSON is good though
# make sure you use -Depth if needed
$ht | ConvertTo-Json
$arrayOfHts | ConvertTo-Json

# Select works (but doesn't in 5.1)
$arrayOfHts | Select-Object Event

# Writing to files
$arrayOfHts | ConvertTo-Json | Out-File -FilePath .\output.json
Get-Content .\output.json
$arrayOfHts | Export-Csv -Path .\output.csv -NoTypeInformation
Get-Content .\output.csv

# Elegant
$arrayOfHts | ForEach-Object {
    [PSCustomObject]$_
}

# or
$arrayOfHts | ForEach-Object {
    New-Object -TypeName PSObject -Property $_
}

# Which is more efficient?
[pscustomobject]@{
    PSCustomObject = Measure-Command {
        foreach ($x in 1..1000) {
            foreach ($item in $arrayOfHts) {
                [PSCustomObject]$item
            }
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
    NewObject      = Measure-Command {
        foreach ($x in 1..1000) {
            foreach ($item in $arrayOfHts) {
                New-Object -TypeName PSObject -Property $item
            }
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
}