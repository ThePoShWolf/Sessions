$ht = @{}
0..10000 | ForEach-Object { $ht[(new-guid).Guid] = @{'blah' = (new-guid).Guid } }

$key = $ht.Keys | Select-Object -first 1
Measure-Command {
    0..100 | ForEach-Object { $ht.keys -contains $key }
}

$key = $ht.Keys | Select-Object -Last 1
Measure-Command {
    0..100 | ForEach-Object { $ht.keys -contains $key }
}

$arr = 0..10000 | ForEach-Object { [pscustomobject]@{
        id   = (new-guid).Guid
        blah = (new-guid).Guid
    } }

$id = $arr[0].id
Measure-Command {
    0..100 | ForEach-Object { $arr | Where-Object { $_.id -eq $id } | Select-Object -first 1 }
}

$id = $arr[5000].id
Measure-Command {
    0..100 | ForEach-Object { $arr | Where-Object { $_.id -eq $id } | Select-Object -first 1 }
}

$id = $arr[10000].id
Measure-Command {
    0..100 | ForEach-Object { $arr | Where-Object { $_.id -eq $id } | Select-Object -first 1 }
}