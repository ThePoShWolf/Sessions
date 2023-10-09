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
$arr.Add

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

# List
# https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-7.0
# List<T>

[System.Collections.Generic.List]::new
[System.Collections.Generic.List[string]]::new()
[System.Collections.Generic.List[int]]::new()
[System.Collections.Generic.List[Discord.Rest.DiscordRestClient]]::new()