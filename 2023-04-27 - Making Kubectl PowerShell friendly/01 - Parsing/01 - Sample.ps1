Import-Module specialK

# If my local kubernetes cluster is working...
$out = kubectl get pod
$out
$out.GetType()
$out[0].GetType()
$out.Count

# If it isn't
$out = @(
    'NAME                                    READY    STATUS     RESTARTS    AGE'
    'database-deployment-194a92db12-b2aat    1/1      Running    0           10d'
    'web-deployment-98ad9380dd-8brg3         1/1      Running    0           2d7h'
)

# headers
$out[0]

# if the output starts with the typical headers
if ($out[0] -match '^(NAME |NAMESPACE |CURRENT |LAST SEEN )') {
    # locate all positions to place semicolons
    # we are using the headers since some values may be null in the data
    if ($null -ne $out) {
        $m = $out[0] | Select-String -Pattern '  \S' -AllMatches
    }

    # view matches
    $m
    $m.Matches | Format-Table

    # place semicolons, order descending
    $out = foreach ($line in $out) {
        foreach ($index in ($m.Matches.Index | Sort-Object -Descending)) {
            $line = $line.Insert($index + 2, ';')
        }
        $line
    }
    
    # view semicolons
    $out

    # objectCommands is the formats.json hashtable
    # will explain when we get to formats
    if ($objectCommands[$args[0]] -contains $args[1]) {
        # select the format type name
        # dynamically determined in the script
        $typeName = "$($args[0])-$($args[1])"
        # manually determined for demo
        $typeName = 'get-pod'
        # output
        $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';' | `
                ForEach-Object { $_.PSObject.TypeNames.Insert(0, $typeName); $_ }
    } else {
        $out -replace ' +;', ';' | ForEach-Object { $_.Trim() } | ConvertFrom-Csv -Delimiter ';'
    }
} else {
    $out
}