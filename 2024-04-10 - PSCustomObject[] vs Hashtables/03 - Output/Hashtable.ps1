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