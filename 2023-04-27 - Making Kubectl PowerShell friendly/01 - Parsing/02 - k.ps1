# This version is from April 2023.
# Please see https://github.com/theposhwolf/specialk for latest version
function k {
    $skipArgs = @(
        'exec', 'cp', 'scale', 'rollout', 'delete', 'logs'
    )
    if ($skipArgs -contains $args[0]) {
        & kubectl $args
    } else {
        $out = (& kubectl $args)
        # if the output starts with the typical headers
        if ($out[0] -match '^(NAME|CURRENT)') {
            # locate all positions to place semicolons
            # we are using the headers since some values may be null in the data
            if ($null -ne $out) {
                $m = $out[0] | Select-String -Pattern '  \S' -AllMatches
            }

            # place semicolons
            $out = foreach ($line in $out) {
                foreach ($index in ($m.Matches.Index | Sort-Object -Descending)) {
                    $line = $line.Insert($index + 2, ';')
                }
                $line
            }

            if ($objectCommands[$args[0]] -contains $args[1]) {
                # select the format type name
                $typeName = "$($args[0])-$($args[1])"
                $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';' | ForEach-Object { $_.PSObject.TypeNames.Insert(0, $typeName); $_ }
            } else {
                # no format likely outputs as a list
                $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';'
            }
        } else {
            $out
        }
    }
}