# Iterate over values in a hashtable using GetEnumerator
$ht.GetEnumerator() | ForEach-Object {
    "Key: $($_.Key)"
    "Value: $($_.Value)"
    #"$($_.Key) - $($_.Value)"
}

# Iterate over values in a hashtable using Keys
$ht.Keys | ForEach-Object {
    "Key: $_"
    "Value: $($ht[$_])"
    #"$_ - $($ht[$_])"
}

# Which is faster?
Measure-Command {
    1..10000 | ForEach-Object { $ht.GetEnumerator() | ForEach-Object {
            "Key: $($_.Key)"
            "Value: $($_.Value)"
        }
    }
}

Measure-Command {
    1..10000 | ForEach-Object { $ht.Keys | ForEach-Object {
            "Key: $_"
            "Value: $($ht[$_])"
        }
    }
}

# Iterate over an array of hashtables
foreach ($item in $arrayOfHts) {
    "Event: $($item.Event)"
    "Date: $($item.Date)"
    "Location: $($item.Location)"
}