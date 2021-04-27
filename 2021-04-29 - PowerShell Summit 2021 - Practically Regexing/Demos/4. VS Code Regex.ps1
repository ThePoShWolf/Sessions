#region Org to Server

# regex
'Org(s)?'

# replaces
'Server$1'

# matches
'Org'
'Orgs'

#endregion

#region Noun prefix

# regex
'-ZCrm'

# replace
'-Demo'

# matches
'-ZCrm'

#endregion

#region Variable change

# regex
'(?<=\$)(script:)?config'

# replace
'$1moduleConfig'

# matches (without replacing the $)
$config
$script:config

#endregion