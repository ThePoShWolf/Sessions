# Users from platform 1
$users1 = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json | Select-Object -First 5000

# Users from platform 2
# reversing the ID order to simulate a different platform
$users2 = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json | ForEach-Object {
    $_.id = 10001 - $_.id
    $_
}

# Find matching users using Where-Object
# Takes about 2-3m on my laptop
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

# Find matching users using PSObjects
# Takes about 20-22s on my laptop
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

# What if we used a list and removed each item from users2 as we go?
[System.Collections.Generic.List[psobject]]$users2list = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json | ForEach-Object {
    $_.id = 10001 - $_.id
    $_
}
Measure-Command {
    $report = foreach ($user1 in $users1) {
        for ($x = 0; $x -lt $users2list.Count; $x++) {
            $user2 = $users2list[$x]
            # match on email
            if ($user1.email -eq $user2.email) {
                [PSCustomObject]@{
                    id1 = $user1.id
                    id2 = $user2.id
                }
                $users2list.RemoveAt($x)
                break
            }
        }
    }
}

# What about hashtables?
@{
    'dhankins0@php.net' = @{
        "id"         = 1001
        "first_name" = "Dasie"
        "last_name"  = "Hankins"
        "email"      = "dhankins0@php.net"
        "title"      = "Assistant Manager"
        "department" = "Engineering"
    }
    #...
}

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

# Is it faster if we also remove keys as we use them?
# Find matching users using hashtables
Measure-Command {
    $report = foreach ($email in $users1ht.Keys) {
        if ($users2ht.ContainsKey($email)) {
            [PSCustomObject]@{
                id1 = $users1ht[$email].id
                id2 = $users2ht[$email].id
            }
            $users2ht.Remove($email)
        }
    }
}

# Alternate method using -contains
# ~2-3s
Measure-Command {
    $report = foreach ($email in $users1ht.Keys) {
        if ($users2ht.Keys -contains $email) {
            [PSCustomObject]@{
                id1 = $users1ht[$email].id
                id2 = $users2ht[$email].id
            }
        }
    }
}