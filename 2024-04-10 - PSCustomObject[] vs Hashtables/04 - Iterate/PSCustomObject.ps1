# Foreach
foreach ($item in $objs) {
    "Event: $($item.Event)"
    "Date: $($item.Date)"
    "Location: $($item.Location)"
}

# ForEach-Object
$objs | ForEach-Object {
    "Event: $($_.Event)"
    "Date: $($_.Date)"
    "Location: $($_.Location)"
}

# For
for ($x = 0; $x -lt $objs.Count; $x++) {
    "Event: $($objs[$x].Event)"
    "Date: $($objs[$x].Date)"
    "Location: $($objs[$x].Location)"
}

# While
$x = 0
while ($x -lt $objs.Count) {
    "Event: $($objs[$x].Event)"
    "Date: $($objs[$x].Date)"
    "Location: $($objs[$x].Location)"
    $x++
}