<#
    Parsing an application's log file
#>

#region Log sample

SOURCE: { ADPID, FirstName LastName, newemail@theposhwolf.com }   
DEST  : { email@theposhwolf.com, FirstName LastName (FirstName LastName) }   
emails[work].value is different: old= "oldemail@theposhwolf.com", new= "newemail@theposhwolf.com"   
userName is different: old= "oldemail@theposhwolf.com", new= "newemail@theposhwolf.com"   
ENT.department is different: old= "", new= "Department of Regexing"   
ENT.division is different: old= "", new= "PowerShell Division"   
ENT.employeeNumber is different: old= "", new= "empnumber"   
ENT.manager is different: old= "oldemail@theposhwolf.com", new= "newemail@theposhwolf.com"   
IAN.physicalDeliveryOfficeName is different: old= "Eugene", new= "Portland"   
newemail@theposhwolf.com: report only, no update   

# Source
SOURCE: { ADPID, FirstName LastName, newemail@theposhwolf.com }   

# Dest
DEST  : { email@theposhwolf.com, FirstName LastName (FirstName LastName) }   

# Property
emails[work].value is different: old= "oldemail@theposhwolf.com", new= "newemail@theposhwolf.com"   

#endregion

#region Source

$source = 'SOURCE: { ADPID, FirstName LastName, newemail@theposhwolf.com }   '

# Start
'^SOURCE: \{ \}'

# Splitting by commas
$source -match "^SOURCE: \{ \w+, [0-9a-zA-Z\-_' ]+, [^ ]+ \}";$Matches

# Add groups
$source -match "^SOURCE: \{ (?<id>\w+), (?<name>[0-9a-zA-Z\-_' ]+), (?<email>[^ ]+) \}";$Matches

#endregion

#region Dest

$dest = 'DEST  : { email@theposhwolf.com, FirstName LastName (FirstName LastName) }   '

# Start
'^DEST  : \{ \}'

# Split by commas
$dest -match '^DEST  : \{ [^,]+, [^}]+ \}';$Matches

# Add in the groups
$dest -match '^DEST  : \{ (?<email>[^,]+), (?<name>[^}]+) \}';$Matches

#endregion

#region Property

$prop1 = 'ENT.employeeNumber is different: old= "", new= "empnumber"   '
$prop2 = 'emails[work].value is different: old= "oldemail@theposhwolf.com", new= "newemail@theposhwolf.com"   '

# Start
'^.+ is different: old= "[^"]*", new= "[^"]+"'
                             ^             ^

$prop1 -match '^.+ is different: old= "[^"]*", new= "[^"]+"';$Matches
$prop2 -match '^.+ is different: old= "[^"]*", new= "[^"]+"';$Matches

# Add groups
$prop1 -match '^(?<prop>.+) is different: old= "(?<old>[^"]*)", new= "(?<new>[^"]+)"';$Matches
$prop2 -match '^(?<prop>.+) is different: old= "(?<old>[^"]*)", new= "(?<new>[^"]+)"';$Matches

#endregion

#region Parse the log!
$logPath = '.\2021-04-29 - PowerShell Summit 2021 - Practically Regexing\Demos\SanitizedLog.txt'
$content = Get-Content $logPath

$sourceRegex = "^SOURCE: \{ (?<id>\w+), (?<name>[0-9a-zA-Z\-_' ]+), (?<email>[^ ]+) \}"
$destRegex = 'DEST  : \{ (?<email>[^,]+), (?<name>[^}]+) \}'
$propRegex = '(?<prop>.+) is different: old= "(?<old>[^"]*)", new= "(?<new>[^"]+)"'

$x = 0
$out = @{}
while ($x -le $content.count) {
    $user = [ordered]@{}
    While ($content[$x] -notlike '---*' -and $x -le $content.Count) {
        if ($content[$x] -match $propRegex) {
            $user[$matches.prop] = @{
                Old = $matches.old
                New = $matches.new
            }
        }elseif ($content[$x] -match $sourceRegex) {
                $user['Source'] = @{
                    AID = $matches.id
                    Name = $matches.name
                    Email = $matches.email
                }
        } elseif ($content[$x] -match $destRegex) {
            $user['Dest'] = @{
                Name = $matches.name
                Email = $matches.email
            }
        }
        $x++
    }
    $out[$user['Source']['AID']] = $user
    $x++
}

$out['ADPID01'] | ConvertTo-Json

#endregion