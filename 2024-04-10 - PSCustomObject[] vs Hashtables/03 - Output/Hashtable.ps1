# Simple
$ht

# But doesn't really look great with an array of hashtables
$arrayOfHts

# Even with formatters
$arrayOfHts | Format-List
$arrayOfHts | Format-Table

# Select works (but doesn't in 5.1)
$arrayOfHts | Select-Object Event

# Sorting
$arrayOfHts | Sort-Object -Property Date
$arrayOfHts | Sort-Object -Property Date -Descending

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