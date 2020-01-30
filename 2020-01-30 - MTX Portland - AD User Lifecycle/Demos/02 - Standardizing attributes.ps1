#region Filter for missing info
#region normal filter
# Define needed info
$properties = 'Name','Department','Title','GivenName','SurName'

# Example filter string
Get-ADUser -Filter "Name -notlike '*'"

# Build a filter
$filterString = "($($properties[0]) -notlike '*')"
For($x=1;$x -lt $properties.count; $x++){
    $filterString += " -or ($($properties[$x]) -notlike '*')"
}
$filterString

# Get those users
Get-ADUser -Filter $filterString -Properties $properties | Format-Table $properties

# Bonus
Get-ADUser -Filter $filterString -Properties $properties | Select $properties | Export-Excel .\MissingProps.xlsx -TableName 'Props'
#endregion

#region Manager Property

# Cleanup
Remove-ADUser 'Jesse.Pinkman' -Confirm:$false

# Prep
New-ADUser 'Jesse.Pinkman'
Set-ADUser 'Jesse.Pinkman' -Manager 'Walter White'

# We can filter for specific managers
Get-ADUser -Filter {Manager -eq 'Walter White'}

# But not empty manager
Get-ADUser -Filter {Manager -eq ''}
Get-ADUser -Filter {Manager -notlike '*'}

# Using an LDAPFilter
Get-ADUser -LDAPFilter "(!manager=*)" -Properties Manager | Format-Table Name,Manager

# Combine both into an LDAP filter
$properties += 'Manager'
$ldapFilter = "(|(!$($properties[0])=*)"
For($x=1;$x -lt $properties.count; $x++){
    $ldapFilter += "(!$($properties[$x])=*)"
}
$ldapFilter += ')'
$ldapFilter

Get-ADUser -LDAPFilter $ldapFilter -Properties $properties | Format-Table $properties

# One issue with using an LDAP filter
Get-ADUser -LDAPFilter '(!surname=*)' | Select-Object GivenName,SurName
Get-ADUser -LDAPFilter '(!sn=*)' | Select-Object GivenName,SurName

# Build a hashtable of values
# https://stackoverflow.com/questions/41447372/is-there-a-complete-list-of-active-directory-attributes-and-a-mapping-to-ldap
$ADAssembly = [Microsoft.ActiveDirectory.Management.ADEntity].Assembly
$LDAPAttributes = $ADAssembly.GetType('Microsoft.ActiveDirectory.Management.Commands.LdapAttributes')
$LDAPNameConstants = $LDAPAttributes.GetFields('Static,NonPublic') | Where-Object {$_.IsLiteral}
$LDAPPropertyMap = @{}
$LDAPNameConstants | ForEach-Object {
    $LDAPPropertyMap[$_.Name] = $_.GetRawConstantValue()
}

# Now
$LDAPPropertyMap
$LDAPPropertyMap['SurName']

# New filter
$ldapFilter = "(|(!$($LDAPPropertyMap[$properties[0]])=*)"
For($x=1;$x -lt $properties.count; $x++){
    $ldapFilter += "(!$($LDAPPropertyMap[$properties[$x]])=*)"
}
$ldapFilter += ')'
$ldapFilter

Get-ADUser -LDAPFilter $ldapFilter -Properties $properties | Format-Table $properties
#endregion

#region Filter to the left
# Compare that to Where-Object
Measure-Command {
    Get-ADUser -LDAPFilter $ldapFilter -Properties $properties
}

Measure-Command {
    Get-ADUser -Filter * -Properties $properties | Where-Object {
        -not $_.Name -or
        -not $_.Department -or
        -not $_.Title -or
        -not $_.Manager -or
        -not $_.GivenName -or
        -not $_.SurName
    }
}
#endregion
#endregion

#region Make it into a function
Function Get-ADUsersMissingInfo {
    [cmdletbinding()]
    Param (
        [string[]]$Properties = @('Name','Department','Title','Manager','GivenName','SurName')
    )
    # Build our property map
    $ADAssembly = [Microsoft.ActiveDirectory.Management.ADEntity].Assembly
    $LDAPAttributes = $ADAssembly.GetType('Microsoft.ActiveDirectory.Management.Commands.LdapAttributes')
    $LDAPNameConstants = $LDAPAttributes.GetFields('Static,NonPublic') | Where-Object {$_.IsLiteral}
    $LDAPPropertyMap = @{}
    $LDAPNameConstants | ForEach-Object {
        $LDAPPropertyMap[$_.Name] = $_.GetRawConstantValue()
    }

    # Find the users
    $ldapFilter = "(|(!$($LDAPPropertyMap[$properties[0]])=*)"
    For($x=1;$x -lt $properties.count; $x++){
        $ldapFilter += "(!$($LDAPPropertyMap[$properties[$x]])=*)"
    }
    $ldapFilter += ')'
    Get-ADUser -LDAPFilter $ldapFilter -Properties $properties
}

# Usage
Get-ADUsersMissingInfo

# Custom
Get-ADUsersMissingInfo -Properties OfficePhone | Select-Object Name,OfficePhone

# Create an Excel sheet
$exportExcelParams = @{
    Autosize = $true
    TableName = 'Props'
    TableStyle = 'Light1'
}
Get-ADUsersMissingInfo | Select-Object $properties |
Export-Excel .\MissingProperties.xlsx -Title 'Missing Properties' @exportExcelParams

Import-Excel .\MissingProperties.xlsx -StartRow 2 | Format-Table

# Copy spreadsheet to local to look at it
Exit
Copy-Item -FromSession $Sessions[0] -Path C:\Users\administrator\documents\MissingProperties.xlsx -Destination '.\2020-01-30 - MTX Portland - AD User Lifecycle\Demos\02 - MissingProperties.xlsx'
Start '.\2020-01-30 - MTX Portland - AD User Lifecycle\Demos\02 - MissingProperties.xlsx'

# Re-enter session
Enter-PSSession $Sessions[0]
#endregion