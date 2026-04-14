# We are assuming that there is only one user with a given email address
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
# Run while explaining
#region spoiler
# takes about 30 seconds on my laptop
#endregion spoiler
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

# parrallel doesn't even help much
#region spoiler
# got it down to about 20 seconds
#endregion spoiler
Measure-Command {
    $report = $users1 | ForEach-Object -ThrottleLimit 1000 -Parallel {
        $user2 = $users2 | Where-Object email -eq $_.email | Select-Object -First 1
        if ($user2) {
            [PSCustomObject]@{
                id1 = $_.id
                id2 = $user2.id
            }
        }
    }
}

# Find matching users using PSObjects
# Faster than O(n^2) on average, but with worst case O(n^2)
# Faster than repeatedly piping to Where-Object
#region spoiler
# about 15 seconds on my laptop
#endregion spoiler
Measure-Command {
    $report = foreach ($user1 in $users1) {
        foreach ($user2 in $users2) {
            # match on email
            if ($user1.email -eq $user2.email) {
                [PSCustomObject]@{
                    id1 = $user1.id
                    id2 = $user2.id
                }
                break # <- this is the magic
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
#region spoiler
# about 100ms on my laptop
#endregion spoiler
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
                $users2list.RemoveAt($x) # <- this and the break are the magic
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
#region spoiler
# about 60ms on my laptop
#endregion spoiler
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
#region spoiler
# about 80ms on my laptop
#endregion spoiler
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

# Alternate methods -contains vs containsKey
# Usually slower than ContainsKey because it scans keys
[pscustomobject]@{
    ContainsKey = Measure-Command {
        foreach ($email in $users1ht.Keys) {
            if ($users2ht.ContainsKey($email)) {
                [PSCustomObject]@{
                    id1 = $users1ht[$email].id
                    id2 = $users2ht[$email].id
                }
            }
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
    '-Contains' = Measure-Command {
        foreach ($email in $users1ht.Keys) {
            if ($users2ht.Keys -contains $email) {
                [PSCustomObject]@{
                    id1 = $users1ht[$email].id
                    id2 = $users2ht[$email].id
                }
            }
        }
    } | Select-Object -ExpandProperty TotalMilliseconds
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

# LINQ Join - purpose-built for matching two collections
# Efficient O(n + m) performance
#region spoiler
# about 20ms on my laptop
#endregion spoiler
Measure-Command {
    $report = [System.Linq.Enumerable]::Join(
        $users1,
        $users2,
        [Func[object, string]] { param($x) $x.email },  # key selector for users1
        [Func[object, string]] { param($x) $x.email },  # key selector for users2
        [Func[object, object, object]] { param($x, $y) 
            [PSCustomObject]@{ 
                id1 = $x.id
                id2 = $y.id 
            } 
        }  # result selector
    )
}

# LINQ using ToDictionary + Where (similar to hashtable approach)
Measure-Command {
    $users2Index = [System.Linq.Enumerable]::ToDictionary(
        $users2,
        [Func[object, string]] { param($x) $x.email }
    )
    
    $report = foreach ($user1 in $users1) {
        if ($users2Index.ContainsKey($user1.email)) {
            [PSCustomObject]@{
                id1 = $user1.id
                id2 = $users2Index[$user1.email].id
            }
        }
    }
}