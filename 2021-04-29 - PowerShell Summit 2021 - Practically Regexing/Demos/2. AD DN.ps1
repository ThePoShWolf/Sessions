# A sample Distinguished Name
$sampleUserDn = 'CN=ThePoShWolf,OU=Oregon,OU=Users,DC=theposhwolf,DC=com'

# Evaluate the DN definition: https://docs.microsoft.com/en-us/previous-versions/windows/desktop/ldap/distinguished-names

#region User's cn:

# The user DN should always start with CN=
'^CN='

# Then, for the the name of the user, we'll use:
# anything but a back slash or comma:
'[^\,]'
# OR a backslash followed by a character (including a back slash or comma):
'\\.'

# Combined with an asterisk to capture 1 or more:
'([^\,]|\\.)*'

# Combined with our start we get:
$sampleUserDn -match '^CN=([^\,]|\\.)*';$Matches

# We can add a group to capture the cn of the user
# And uncapture the last group:
$sampleUserDn -match '^CN=(?<cn>(?:[^\,]|\\.)*)';$Matches
$Matches.cn

#endregion

# First, we can validate if it is a valid DN:
$sampleUserDn -match '^CN=([^\,]|\\.)*,((OU|CN)=([^\,]|\\.)*,)*(DC=([^\,]|\\.)*,)*(DC=([^\,]|\\.)*)$'

'^CN=(?<cn>(?:[^\,]|\\.)*),(?<path>(?:(?:OU|CN)=(?:[^\,]|\\.)*,)*(?<domain>(?:DC=(?:[^\,]|\\.)*,)*(?:DC=(?:[^\,]|\\.)*)))$'