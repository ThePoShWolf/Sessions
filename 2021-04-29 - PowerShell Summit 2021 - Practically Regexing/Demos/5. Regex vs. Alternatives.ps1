#region AD DN

$sampleUserDn = 'CN=ThePoShWolf,OU=Oregon,OU=Users,DC=theposhwolf,DC=com'
$regex = '^CN=(?<cn>(?:[^\,]|\\.)+),(?<path>(?:(?:OU|CN)=(?:[^\,]|\\.)+,)+(?<domain>(?:DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+(?:DC=(?!-)[a-zA-Z0-9-]{2,6}(?<!-))))'

$count = 10000

Measure-Command {
    for($x=0; $x -lt $count; $x++) {
        $sampleUserDn -match $regex
    }
}

Measure-Command {
    for($x=0; $x -lt $count; $x++) {
        $arr = $sampleUserDn.Split(',')
        @{
            cn = $arr[0].Split('=')[1]
            path = $arr[1..$arr.Count] -join ','
            domain = ($arr | ?{$_ -like 'DC=*'}) -join ','
        }
    }
}

Measure-Command {
    for($x=0; $x -lt $count; $x++) {
        @{
            cn = $sampleUserDn.Substring($sampleUserDn.IndexOf('=')+1,$sampleUserDn.IndexOf(',')-$sampleUserDn.IndexOf('=')-1)
            path = $sampleUserDn.Substring($sampleUserDn.IndexOf(',')+1)
            domain = $sampleUserDn.substring($sampleUserDn.IndexOf(',DC')+1)
        }
    }
}

#endregion

#region Log file

$source = 'SOURCE: { ADPID, FirstName LastName, newemail@theposhwolf.com }   '
$dest = 'DEST  : { email@theposhwolf.com, FirstName LastName (FirstName LastName) }   '
$prop1 = 'ENT.employeeNumber is different: old= "", new= "empnumber"   '

$sourceRegex = "^SOURCE: \{ (?<id>\w+), (?<name>[0-9a-zA-Z\-_' ]+), (?<email>[^ ]+) \}"
$destRegex = '^DEST  : \{ (?<email>[^,]+), (?<name>[^}]+) \}'
$propRegex = '^(?<prop>\S+) is different: old= "(?<old>[^"]*)", new= "(?<new>[^"]+)"'

$count = 100000

Measure-Command {
    for($x=0; $x -lt $count; $x++) {
        $source -match $sourceRegex
        $dest -match $destRegex
        $prop1 -match $propRegex
    }
}

Measure-Command {
    for($x=0; $x -lt $count; $x++) {
        # Source
        $firstComma = $source.IndexOf(',')
        $secondComma = $source.IndexOf(',',$firstComma+1)
        @{
            id = $source.Substring($source.IndexOf('{')+2,$firstComma-$source.IndexOf('{')-2)
            name = $source.Substring($firstComma+2,($secondComma)-$firstComma-2)
            email = $source.Substring($secondComma+2,$source.IndexOf('}')-$secondComma-2)
        }
        # Dest
        @{
            email = $dest.Substring($dest.IndexOf('{')+2,$dest.IndexOf(',')-$dest.IndexOf('{')-2)
            name = $dest.Substring($dest.IndexOf(',')+2,$dest.IndexOf('}')-$dest.IndexOf(',')-2)
        }
        # Prop
        $firstQuote = $prop1.IndexOf('"')
        $secondQuote = $prop1.IndexOf('"',$firstQuote+1)
        $thirdQuote = $prop1.IndexOf('"',$secondQuote+1)
        $fourthQuote = $prop1.IndexOf('"',$thirdQuote+1)
        @{
            prop = $prop1.Substring(0,$prop1.IndexOf(' '))
            old = $prop1.Substring($firstQuote+1,$secondQuote-$firstQuote-1)
            new = $prop1.Substring($thirdQuote+1,$fourthQuote-$thirdQuote-1)
        }
    }
}

#endregion