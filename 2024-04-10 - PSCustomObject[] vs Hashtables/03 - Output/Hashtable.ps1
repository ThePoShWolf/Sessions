# Select multiple keys
$ht['Event', 'Location']

# Simple, full output
$ht

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

# Sorting
$arrayOfHts | Sort-Object -Property Date
$arrayOfHts | Sort-Object -Property Date -Descending

# Writing to files
$arrayOfHts | ConvertTo-Json | Out-File -FilePath .\output.json
$arrayOfHts | Export-Csv -Path .\output.csv -NoTypeInformation

# Elegant
$arrayOfHts | ForEach-Object {
    [PSCustomObject]$_
}

# or
$arrayOfHts | ForEach-Object {
    New-Object -TypeName PSObject -Property $_
}

# Which is more efficient?
Measure-Command {
    1..10000 | ForEach-Object { $arrayOfHts | ForEach-Object {
            [PSCustomObject]$_
        }
    }
}

Measure-Command {
    1..10000 | ForEach-Object { $arrayOfHts | ForEach-Object {
            New-Object -TypeName PSObject -Property $_
        }
    }
}