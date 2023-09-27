# Examples of types:

# string
"string"

# integer (int32)
42

# boolean
$true

# DateTime
Get-Date

# hashtable (dictionary)
@{
    key = "value"
}

# PSCustomObject
[pscustomobject]@{
    Property = "Value"
}

# Example of a built-in .NET type
(Get-Process)[0]

# How to get an object's type

(Get-ChildItem)[0].GetType()
(Get-ChildItem)[0].GetType().FullName