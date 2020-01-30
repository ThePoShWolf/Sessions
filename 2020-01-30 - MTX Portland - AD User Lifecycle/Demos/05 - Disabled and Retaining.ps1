#region
# Prep
Set-ADAccountPassword 'Jesse.Pinkman' -NewPassword (ConvertTo-SecureString 'Password1234!' -AsPlainText -Force) -Reset
Set-ADUser 'Jesse.Pinkman' -Description 'Partner' -Enabled $true

# Disable a user account
$user = Get-ADUser 'Jesse.Pinkman' -Properties Description
$user.Enabled
Disable-ADAccount $user

# Tag the description
Set-ADUser $user -Description "$($user.Description) - Disabled $((Get-Date).ToShortDateString())"
(Get-ADUser 'Jesse.Pinkman' -Properties Description).Description

# Retain it
$disabledOU = 'OU=Disabled,OU=People,DC=techsnipsdemo,DC=org'
Move-ADObject -Identity $user.DistinguishedName -TargetPath $disabledOU

# Verify
(Get-ADUser jesse.pinkman).DistinguishedName
#endregion

#region fix
Set-aduser jesse.pinkman -Description 'Partner' -Enabled $true
Move-ADObject -Identity (Get-ADUser jesse.pinkman).DistinguishedName -TargetPath 'OU=People,DC=techsnipsdemo,DC=org'
#endregion

#region Of course make that a function!
Function Invoke-ADUserOffboarding {
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory = $true
        )]
        [Microsoft.ActiveDirectory.Management.ADUser]$Identity,
        [string]$DisabledOU = 'OU=Disabled,OU=People,DC=techsnipsdemo,DC=org'
    )
    # Grab the user
    $user = Get-ADUser $Identity -Properties Description
    # Disable the account
    Disable-ADAccount $user
    # Tag it
    Set-ADUser $user -Description "$($user.Description) - Disabled $((Get-Date).ToShortDateString())"
    # Move it to the disabled OU
    Move-ADObject -Identity $user.DistinguishedName -TargetPath $DisabledOU
}

# Usage
Invoke-ADUserOffboarding jesse.pinkman

# Verify
Get-ADUser jesse.pinkman -Properties Description

#endregion