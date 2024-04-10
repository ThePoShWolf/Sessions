# Iterate over values in a hashtable using GetEnumerator
$ht.GetEnumerator() | ForEach-Object {
    "Key: $($_.Key)"
    "Value: $($_.Value)"
}

# Iterate over values in a hashtable using Keys
$ht.Keys | ForEach-Object {
    "Key: $_"
    "Value: $($ht[$_])"
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

# You can also use foreach
foreach ($key in $ht.Keys) {
    "Key: $key"
    "Value: $($ht[$key])"
}

# Or a for loop, maybe?
for ($x = 0; $x -lt $ht.Count; $x++) {
    "Key: $($ht.Keys[$x])"
    "Value: $($ht[$ht.Keys[$x]])"
}

# Just don't try to modify the hashtable while iterating
foreach ($key in $ht.Keys) {
    Write-Host "Removing key $key..."
    $ht.Remove($key)
}
$ht

# Iterate over an array of hashtables
foreach ($item in $arrayOfHts) {
    "Event: $($item.Event)"
    "Date: $($item.Date)"
    "Location: $($item.Location)"
}

# Nested hashtable
$veryNestedHt = [ordered]@{
    a = [ordered]@{
        a1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        b1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        c1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
    }
    b = [ordered]@{
        a1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        b1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        c1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
    }
    c = [ordered]@{
        a1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        b1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
        c1 = @{
            a2 = 'a3'
            b2 = 'b3'
            c2 = 'c3'
        }
    }
}

# Iterate over a very nested hashtable with long notation
foreach ($key in $veryNestedHt.Keys) {
    "Key: $key"
    foreach ($subKey in $veryNestedHt[$key].Keys) {
        "SubKey: $subKey"
        foreach ($subSubKey in $veryNestedHt[$key][$subKey].Keys) {
            "SubSubKey: $subSubKey"
            "SubSubValue: $($veryNestedHt[$key][$subKey][$subSubKey])"
        }
    }
}

# Iterate over a very nested hashtable with shorter notation
foreach ($key in $veryNestedHt.Keys) {
    "Key: $key"
    $nestedHt = $veryNestedHt[$key]
    foreach ($nestedHtKey in $nestedHt.Keys) {
        "NestedHtKey: $nestedHtKey"
        $nestedHt1 = $nestedHt[$nestedHtKey]
        foreach ($nestedHt1Key in $nestedHt1.Keys) {
            "NestedHt1Key: $nestedHt1Key"
            "NestedHt1Value: $($nestedHt1[$nestedHt1Key])"
        }
    }
}