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

# Combined with an plus sign to capture 1 or more:
'([^\,]|\\.)+'

# Combined with our start we get:
$sampleUserDn -match '^CN=([^\,]|\\.)+,';$Matches

# We can add a group to capture the cn of the user
# And uncapture the last group:
$sampleUserDn -match '^CN=(?<cn>(?:[^\,]|\\.)+),';$Matches
$Matches.cn

#endregion

#region Path
$userRegex = '^CN=(?<cn>(?:[^\,]|\\.)+),'

# The user will be in an OU or container, so we'll need to account for either:
'(OU|CN)'

# And the name of said container or OU uses the same naming requirements as the user's CN,
# so we'll use the same regex:
'(OU|CN)=(?:[^\,]|\\.)+'

# And the user could be in nested OUs or containers, so we'll account for 1 or more:
'((OU|CN)=(?:[^\,]|\\.)+,)+'

# Adding it to the userRegex:
$sampleUserDn -match "$userRegex((OU|CN)=([^\,]|\\.)+,)+";$Matches

# And then we'll clean up the groupings:
$sampleUserDn -match "$userRegex(?<path>(?:(?:OU|CN)=(?:[^\,]|\\.)+,)+)";$Matches

#endregion

#region Domain
$pathRegex = '(?<path>(?:(?:OU|CN)=(?:[^\,]|\\.)+,)+)'

# We know the domain section starts with DC:
'DC='

# And for the domain name, we can use a stricter character set
# Characters, digits, and hyphens, but it can't start or end with a hyphen
# This is where look arounds can come into play:
'(?!-)[a-zA-Z0-9-]+(?<!-)'

# so for the domain:
'DC=(?!-)[a-zA-Z0-9-]+(?<!-),'

# And since we may be in a subdomain:
'(DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+'

# And accounting for the TLD (including length):
'(DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+(DC=(?!-)[a-zA-Z0-9-]{2,6}(?<!-))'

# Testing that with our existing regex:
$sampleUserDn -match "$userRegex$PathRegex(DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+(DC=(?!-)[a-zA-Z0-9-]{2,6}(?<!-))$";$Matches

# Adding in the grouping:
$sampleUserDn -match "$userRegex$PathRegex(?<domain>(?:DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+(?:DC=(?!-)[a-zA-Z0-9-]{2,6}(?<!-)))$";$Matches

#endregion

#region Final Product

$sampleUserDn -match '^CN=(?<cn>(?:[^\,]|\\.)+),(?<path>(?:(?:OU|CN)=(?:[^\,]|\\.)+,)+(?<domain>(?:DC=(?!-)[a-zA-Z0-9-]+(?<!-),)+(?:DC=(?!-)[a-zA-Z0-9-]{2,6}(?<!-))))';$Matches

#endregion