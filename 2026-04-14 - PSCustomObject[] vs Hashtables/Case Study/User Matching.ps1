$path = '.\MOCK_DATA.json'

# Users from platform 1
$users1 = Get-Content $path | ConvertFrom-Json | Select-Object -First 5000

# Users from platform 2
# reversing the ID order to simulate a different platform
$users2 = Get-Content $path | ConvertFrom-Json | ForEach-Object {
    $_.id = 10001 - $_.id
    $_
}

# Find matching users using Where-Object
# Intentionally O(n^2): clear but expensive at scale
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
# Faster than O(n^2) on average, but with worst case O(n^2)
# Faster than repeatedly piping to Where-Object
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

# Aren't lists suppossed to be fast?
# What if we used a list and removed each item from users2 as we go?
[System.Collections.Generic.List[psobject]]$users2list = Get-Content $path | ConvertFrom-Json | ForEach-Object {
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
# O(1)
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

# re-build $users2ht
$users2ht = @{}
foreach ($user in $users2) {
    $users2ht[$user.email] = $user
}

# Alternate method using -contains
# Usually slower than ContainsKey because it scans keys
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

# vs .ContainsKey
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

# Recommended pattern: index once, then do O(1) lookups
# Copilot's recommendation
Measure-Command {
    $users2Index = @{}
    foreach ($user in $users2) {
        $users2Index[$user.email] = $user
    }

    $report = foreach ($user1 in $users1) {
        if ($users2Index.ContainsKey($user1.email)) {
            [PSCustomObject]@{
                id1 = $user1.id
                id2 = $users2Index[$user1.email].id
            }
        }
    }
}

$report | Select-Object -First 10