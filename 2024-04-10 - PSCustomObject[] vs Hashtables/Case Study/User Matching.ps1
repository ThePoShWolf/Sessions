# Users from platform 1
$users1 = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json

# Users from platform 2
# reversing the ID order to simulate a different platform
$users2 = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json | ForEach-Object {
    $_.id = 10001 - $_.id
    $_
}

# Find matching users using PSObjects
# Takes about 68s on my laptop
Measure-Command {
    $report = foreach ($user1 in $users1) {
        foreach ($user2 in $users2) {
            # match on email
            if ($user1.email -eq $user2.email) {
                [PSCustomObject]@{
                    id1 = $user1.id
                    id2 = $user2.id
                }
                break
            }
        }
    }
}

# Try with Where-Object
# Takes about 6.5m on my laptop
Measure-Command {
    $report = foreach ($user1 in $users1) {
        $user2 = $users2 | Where-Object email -eq $user1.email | Select-Object -First 1
        if ($user2) {
            [PSCustomObject]@{
                id1 = $user1.id
                id2 = $user2.id
            }
        }
    }
}

# What about hashtables?
$users1ht = @{}
foreach ($user in $users1) {
    $users1ht[$user.email] = $user
}

$users2ht = @{}
foreach ($user in $users2) {
    $users2ht[$user.email] = $user
}

# Find matching users using hashtables
Measure-Command {
    $report = foreach ($email in $users1ht.Keys) {
        if ($users2ht.ContainsKey($email)) {
            [PSCustomObject]@{
                id1 = $users1ht[$email].id
                id2 = $users2ht[$email].id
            }
        }
    }
}