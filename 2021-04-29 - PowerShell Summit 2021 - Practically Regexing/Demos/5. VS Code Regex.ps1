#region Org to Server

# regex
'Org(s)?'

# matches
'Org'
'Orgs'

#endregion

#region Noun prefix

# regex
'-ZCrm'

# matches
'-ZCrm'

#endregion

#region Variable change

# regex
'(?<=\$)(script:)?config'

# matches (without replacing the $)
$config
$script:config

#endregion