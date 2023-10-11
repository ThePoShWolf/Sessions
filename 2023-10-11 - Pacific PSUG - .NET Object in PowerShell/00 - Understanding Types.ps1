# Examples of types:

# string
"string"
"string".GetType()

# integer (int32)
42
$answer = 42
$answer.GetType()

# boolean
$true
$true.GetType()

# DateTime
Get-Date
(Get-Date).GetType()

# hashtable (dictionary)
@{
    key = "value"
}
@{
    key = "value"
}.GetType()

# PSCustomObject
[pscustomobject]@{
    Property = "Value"
}
$obj = [pscustomobject]@{
    Property = "Value"
}
$obj.GetType()

# Example of a built-in .NET type
(Get-Process)[0]
(Get-Process)[0].GetType()
(Get-Process)[0].GetType().FullName

# How to get an object's type

(Get-ChildItem)[0].GetType()
(Get-ChildItem)[0].GetType().FullName

# They can all use Get-Member

"string" | Get-Member
42 | Get-Member
$true | Get-Member
Get-Date | Get-Member
@{
    key = "value"
} | Get-Member
[pscustomobject]@{
    Property = "Value"
} | Get-Member
(Get-Process)[0] | Get-Member
(Get-ChildItem)[0] | Get-Member