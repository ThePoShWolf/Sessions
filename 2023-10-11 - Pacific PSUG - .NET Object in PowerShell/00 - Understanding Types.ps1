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

# How to get an object's type

(Get-ChildItem)[0].GetType()
(Get-ChildItem)[0].GetType().FullName