# Everything is a string
$pods = k get pod
$pods
$pods[0].RESTARTS.GetType()

# Even top
$top = k top pod
$top
$top[0].'MEMORY(bytes)'.GetType()

# But you can still compare some of the data, at least in PowerShell 7
$pods | Where-Object { $_.RESTARTS -lt 3 }
$pods | Where-Object { $_.RESTARTS -eq 2 }

# top compare
$top | Where-Object { $_.'MEMORY(bytes)' -gt 200 }

# getting creative with top
k top pod --sort-by=memory | Select-Object -First 1
k top node --sort-by=cpu | Select-Object -First 1

# Doesn't work well with 'LAST SEEN' in events
$events = k get events
$events | Format-Table
$events | Where-Object { $_.'LAST SEEN' -gt (Get-Date).AddMinutes(-45) } | Format-Table
$events | Where-Object { $_.'LAST SEEN' -lt '45m' } | Format-Table

# You can get creative
$events | Where-Object { $_.'LAST SEEN' -like '*m' -and $_.'LAST SEEN' -lt 45 } | Format-Table
k get events --sort-by='lastTimestamp' | Select-Object -Last 5 | Format-Table

# String -gt and -lt is sketchy
# Be aware that in Windows PowerShell 5.1, this is $false:
'0' -gt -1

# and this is $true
'0' -lt 1