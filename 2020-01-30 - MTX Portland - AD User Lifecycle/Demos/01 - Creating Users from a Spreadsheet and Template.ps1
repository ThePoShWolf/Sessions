<#
    Install-Module ImportExcel
    Import-Module ActiveDirectory
#>

#region prep work
# Import the spreadsheet
$SpreadSheet = '.\UserUpdate.xlsx'
$Data = Import-Excel $SpreadSheet

# Check the data
$Data | Format-Table

# Correlate fields
$expectedProperties = @{
    Name = 'Full Name'
    GivenName = 'First Name'
    SurName = 'Last Name'
    Title = 'Job Title'
    Department = 'Department'
    OfficePhone = 'Phone Number'
}

# Correlate 'Manager' field
Help New-ADUser -Parameter Manager

<# <ADUser> can be:
    SamAccountName
    DistinguishedName
    GUID
    SID
#>

Get-ADUser $Data[0].Manager

Get-ADUser $Data[0].Manager.Replace(' ','.')

# Manager
$Data[0].Manager.Replace(' ','.')

# SamAccountName
"$($Data[0].'First Name').$($Data[0].'Last Name')"

# Create a single user
$user = $Data[0]
$params = @{}
ForEach($property in $expectedProperties.GetEnumerator()){
    # If the new user has the property
    If($user."$($property.value)".Length -gt 0){
        # Add it to the splat
        $params["$($property.Name)"] = $user."$($property.value)"
    }
}
# Deal with other values
If($user.Manager.length -gt 0){
    $params['Manager'] = $user.Manager.Replace(' ','.')
}
$params['SamAccountName'] = "$($user.$($expectedProperties['GivenName'])).$($user.$($expectedProperties['SurName']))"
# Create the user
New-ADUser @params

#endregion

#region Create a function
Function Import-ADUsersFromSpreadsheet {
    [cmdletbinding()]
    Param(
        [ValidatePattern('.*\.xlsx$')]
        [ValidateNotNullOrEmpty()]
        [string]$PathToSpreadsheet
    )
    # Hashtable to correlate properties
    $expectedProperties = @{
        Name = 'Full Name'
        GivenName = 'First Name'
        SurName = 'Last Name'
        Title = 'Job Title'
        Department = 'Department'
        OfficePhone = 'Phone Number'
    }
    # Make sure the xlsx exists
    If(Test-Path $PathToSpreadsheet){
        $data = Import-Excel $PathToSpreadsheet
        ForEach($user in $data){
            # Build a splat
            $params = @{}
            ForEach($property in $expectedProperties.GetEnumerator()){
                # If the new user has the property
                If($user."$($property.value)".Length -gt 0){
                    # Add it to the splat
                    $params["$($property.Name)"] = $user."$($property.value)"
                }
            }
            # Deal with other values
            If($user.Manager.length -gt 0){
                $params['Manager'] = $user.Manager.Replace(' ','.')
            }
            $params['SamAccountName'] = "$($user.$($expectedProperties['GivenName'])).$($user.$($expectedProperties['SurName']))"
            # Create the user
            New-ADUser @params
        }
    }
}

# Usage
Import-ADUsersFromSpreadsheet -PathToSpreadsheet '.\UserUpdate.xlsx'

# Verify
ForEach($user in $data){
    Get-ADUser "$($user.'First Name').$($user.'Last Name')" | Select-Object Name
}
#endregion

#region Create a template user
New-ADUser -Name 'Template User' -Enabled $false

# Set all your template properties
Set-ADUser 'Template User' -StreetAddress '308 Negra Arroyo Lane' -City 'Albuquerque' -State 'New Mexico' -PostalCode '87104'

# Add any groups
$BaseGroups = 'EveryBody','Main File Share Access'
ForEach($group in $BaseGroups){
    Add-ADGroupMember $group -Members 'Template User'
}

# Verify
Get-ADUser 'Template User' -Properties StreetAddress,City,State,PostalCode,MemberOf

#endregion

#region Creating users from the template
# Retrieve the template user
$user = Get-ADUser 'Template User' -Properties StreetAddress,City,State,PostalCode,MemberOf

# Create a single user from that
New-ADUser 'Walter White' -GivenName 'Walter' -Surname 'White' -Instance $user

# Check Groups
(Get-ADUser 'Walter White' -Properties MemberOf).MemberOf

# Add that user to the same groups
ForEach($group in $user.MemberOf){
    Add-ADGroupMember $group -Members 'Walter White'
}

# Verify
Get-ADUser 'Walter White' -Properties StreetAddress,City,State,PostalCode
(Get-ADUser 'Walter White' -Properties MemberOf).MemberOf

#endregion

#region Function time!
# Create your spreadsheet users using the template as well
Function Import-ADUsersFromSpreadsheet {
    [cmdletbinding(
        DefaultParameterSetName = 'Plain'
    )]
    Param(
        [ValidatePattern('.*\.xlsx$')]
        [ValidateNotNullOrEmpty()]
        [Parameter(
            ParameterSetName = 'FromTemplate'
        )]
        [Parameter(
            ParameterSetName = 'Plain'
        )]
        [string]$PathToSpreadsheet,
        [Parameter(
            ParameterSetName = 'FromTemplate',
            Mandatory = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADUser]$TemplateUser,
        [Parameter(
            ParameterSetName = 'FromTemplate'
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Properties = @('StreetAddress','City','State','PostalCode')
    )
    # Hashtable to correlate properties
    $expectedProperties = @{
        Name = 'Full Name'
        GivenName = 'First Name'
        SurName = 'Last Name'
        Title = 'Job Title'
        Department = 'Department'
        OfficePhone = 'Phone Number'
    }
    # Make sure the xlsx exists
    If(Test-Path $PathToSpreadsheet){
        $data = Import-Excel $PathToSpreadsheet
        ForEach($user in $data){
            # Build a splat
            $params = @{}
            ForEach($property in $expectedProperties.GetEnumerator()){
                # If the new user has the property
                If($user."$($property.value)".Length -gt 0){
                    # Add it to the splat
                    $params["$($property.Name)"] = $user."$($property.value)"
                }
            }
            # Deal with other values
            If($user.Manager.length -gt 0){
                $params['Manager'] = $user.Manager.Replace(' ','.')
            }
            $params['SamAccountName'] = "$($user.$($expectedProperties['GivenName'])).$($user.$($expectedProperties['SurName']))"
            # Create the user
            If($PSCmdlet.ParameterSetName -eq 'Plain'){
                New-ADUser @params
            }ElseIf($PSCmdlet.ParameterSetName -eq 'FromTemplate'){
                $props = $Properties + 'MemberOf'
                $template = Get-ADUser $TemplateUser -Properties $props
                New-ADUser @params -Instance $template
                ForEach($group in $template.MemberOf){
                    Add-ADGroupMember $group -Members $params['samaccountname']
                }
            }
        }
    }
}

# Usage
Import-ADUsersFromSpreadsheet -PathToSpreadsheet '.\UserUpdate.xlsx' -TemplateUser 'Template User'

# Verify
$SpreadSheet = '.\UserUpdate.xlsx'
$data = Import-Excel $SpreadSheet
ForEach($user in $data){
    Get-ADUser "$($user.'First Name').$($user.'Last Name')" -Properties StreetAddress,MemberOf | Select-Object Name,StreetAddress,MemberOf
}

#endregion