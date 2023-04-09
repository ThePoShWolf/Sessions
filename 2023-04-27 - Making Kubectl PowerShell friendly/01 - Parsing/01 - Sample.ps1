$out = @(
    'NAME                                    READY    STATUS     RESTARTS    AGE'
    'database-deployment-194a92db12-b2aat    1/1      Running    0           10d'
    'web-deployment-98ad9380dd-8brg3         1/1      Running    0           2d7h'
)

# if the output starts with the typical headers
if ($out[0] -match '^(NAME|CURRENT)') {
    # locate all positions to place semicolons
    # we are using the headers since some values may be null in the data
    if ($null -ne $out) {
        $m = $out[0] | Select-String -Pattern '  \S' -AllMatches
    }

    # view matches
    $m

    # place semicolons
    $out = foreach ($line in $out) {
        foreach ($index in ($m.Matches.Index | Sort-Object -Descending)) {
            $line = $line.Insert($index + 2, ';')
        }
        $line
    }
    
    # view semicolons
    $out

    if ($objectCommands[$args[0]] -contains $args[1]) {
        # select the format type name
        # dynamicall determined in the script
        $typeName = "$($args[0])-$($args[1])"
        # manually determined for demo
        $typeName = 'get-pod'
        # output
        $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';' | ForEach-Object { $_.PSObject.TypeNames.Insert(0, $typeName); $_ }
    } else {
        $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';'
    }
} else {
    $out
}