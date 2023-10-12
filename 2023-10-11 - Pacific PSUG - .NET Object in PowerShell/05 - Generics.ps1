# Generics are types that are meant to work with any other type, or a specific set of types
# Built in examples:

# Array
# https://learn.microsoft.com/en-us/dotnet/api/system.object?view=net-7.0

@(
    'string',
    42,
    (Get-Date)
)
$arr = @(
    'string',
    42,
    (Get-Date)
)
$arr.GetType()
$arr.GetType().FullName

# Methods

[System.Object[]]::new

# Generic add
$arr.Add

# How are a string, integer, and datetime all System.Object?
# Polymorphism: https://en.wikipedia.org/wiki/Polymorphism_(computer_science)

$arr[0].GetType().BaseType
$arr[1].GetType().BaseType
$arr[2].GetType().BaseType

$client.GetType().BaseType

# Hashtable
# https://learn.microsoft.com/en-us/dotnet/api/system.collections.hashtable?view=net-7.0

$ht = @{
    Key = 'value'
}
$ht.GetType()
$ht.GetType().FullName

# Methods

[System.Collections.Hashtable]::new
$ht.Add

# Crazy example
$ht.Add($client, $arr)

# List
# https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-7.0
# List<T>

[System.Collections.Generic.List]::new

# working lists

$strList = [System.Collections.Generic.List[string]]::new()
$strList.Add

[System.Collections.Generic.List[int]]::new()
[System.Collections.Generic.List[Discord.Rest.DiscordRestClient]]::new()

# One list for anything 

$list = [System.Collections.Generic.List[System.Object]]::new()
$list.Add
$list.Add($ht)
$list.Add($client)
$list

# old:
[System.Collections.ArrayList]

# new:
[System.Collections.Generic.List[System.Object]]