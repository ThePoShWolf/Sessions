#region Reading json
# from a file
& '.\2020-01-30 - MTX Portland - REST APIs\Demos\01 - Data.json'

$jsonFile = '.\2020-01-30 - MTX Portland - REST APIs\Demos\01 - Data.json'

## Reading it into a psobject
$json = Get-Content $jsonFile | ConvertFrom-Json

$json
$json.items
$json.items[0]
$json.items[0].owner

# From a string
$str = @'
{
    "month":"1",
    "num":2257,
    "link":"",
    "year":"2020",
    "news":"",
    "safe_title":"Unsubscribe Message",
    "transcript":"",
    "alt":"A mix of the two is even worse: 'Thanks for unsubscribing and helping us pare this list down to reliable supporters.'",
    "img":"https://imgs.xkcd.com/comics/unsubscribe_message.png",
    "title":"Unsubscribe Message",
    "day":"20"
}
'@

$json = $str | ConvertFrom-Json

$json
#endregion

#region Converting and writing json
# From a PSObject
Get-Process
$process = Get-Process | Select -First 5

$process.PSObject.TypeNames

$process | ConvertTo-Json -Depth 10

$process | ConvertTo-Json -Compress

# From a hashtable
$ht = @{
    Key = 'Value'
    Key1 = 'Value1'
    Key2 = 'Value2'
    SubArray = @(
        @{
            SubArrayKey = 'SubArrayValue1'
        },
        @{
            SubArrayKey = 'SubArrayValue2'
        }
    )
}

$ht | ConvertTo-Json

## Converting from json to a hashtable, v6+
$str | ConvertFrom-Json -AsHashtable

#endregion