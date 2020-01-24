#region
# Prep
Get-ADUser -Filter * | %{Set-ADUser $_ -AccountExpirationDate $null}

$count = 5
$randomUsers = Get-ADUser -LDAPFilter "(manager=*)"
for($x=0;$x-lt 5;$x++) {
    $rand = 1..13 | Get-Random
    $randomUsers | Get-Random | Set-ADUser -AccountExpirationDate (Get-Date).AddDays($rand)
}

# Finding accounts soon to expire
$users = Search-ADAccount -AccountExpiring -TimeSpan '14.00:00:00'
$users[0]

# Adding the manager field
$users = Search-ADAccount -AccountExpiring -TimeSpan '14.00:00:00' | Get-ADUser -Properties Manager,AccountExpirationDate
$users[0]

# Find their manager
ForEach($user in $users){
    Get-ADUser $user.Manager
}
#endregion

#region Notify
# Group the users by their manager
$groupedUsers = $users | Group-Object Manager
$groupedUsers

# Format the users
$tableInfo = ''
ForEach($user in $groupedUsers[0].Group){
    $ts = New-TimeSpan -Start (Get-Date) -End $user.AccountExpirationDate
    [string]$tableInfo += "<tr><th>$($user.Name)</th><th>$($ts.Days)</th></tr>"
}
$tableInfo

# Put them in HTML
$header = @"
<style>
table, th, td {
    border: 1px solid black;
  }
</style>
"@

$htmlTemplate = @"
<h1>Hello {0},</h1>
<p>You have minions with accounts that expire soon.</p>
<table>
    <tr>
        <th>Name</th>
        <th>Days till expiration</th>
    </tr>
    {1}
</table>
<p>Thanks!</p>
<p>Your friendly, neighborhood PowerShell automation system.</p>
"@

#region Emails in PowerShell
# Sending an email
$exampleParams = @{
    Subject = 'Email subject line'
    Body = '<h1>Body</h1><p>this is the paragraph</p>'
    BodyAsHtml = $true
    To = 'email@domain.com'
    From =  'email@domain.coum'
    SmtpServer = 'smtp.domain.com'
    UseSSL = $true
}
Send-MailMessage @params
#endregion
$manager = Get-ADUser $groupedUsers[0].Name -Properties EmailAddress
$html = $header + ($htmlTemplate -f $manager.GivenName,$tableInfo)

# To send the email
$params['body'] = $html
$param['To'] = $manager.EmailAddress
Send-MailMessage @params

# Copy the file to the local computer via PS Session
$html | Out-File .\html.html
exit
Copy-Item -FromSession $Sessions[0] -Path C:\users\administrator\documents\html.html -Destination '.\2020-01-30 - MTX Portland - AD User Lifecycle\Demos\04 - html.html'
start '.\2020-01-30 - MTX Portland - AD User Lifecycle\Demos\04 - html.html'

# Jump back in the session
Enter-PSSession $Sessions[0]

#endregion

#region Don't forget to functionize it!
Function Send-ADAccountExpirations {
    param (
        [int]$DaysTillExpiration,
        [pscredential]$EmailCredential = $cred,
        [string]$From
    )
    $header = @"
<style>
table, th, td {
    border: 1px solid black;
    }
</style>
"@
    $htmlTemplate = @"
<h1>Hello {0},</h1>
<p>You have minions with accounts that expire soon.</p>
<table>
    <tr>
        <th>Name</th>
        <th>Days till expiration</th>
    </tr>
    {1}
</table>
<p>Thanks!</p>
<p>Your friendly, neighborhood PowerShell automation system.</p>
"@
    # Get the expiring users
    $users = Search-ADACcount -AccountExpiring -TimeSpan "$DaysTillExpiration.00:00:00" | Get-ADUser -Properties Manager,AccountExpirationDate
    # Group them
    $groupedUsers = $users | Group-Object Manager
    # Send the emails
    ForEach($group in $groupedUsers){
        $tableInfo = $null
        ForEach($user in $group.Group){
            $ts = New-TimeSpan -Start (Get-Date) -End $user.AccountExpirationDate
            [string]$tableInfo += "<tr><th>$($user.Name)</th><th>$($ts.Days)</th></tr>"
        }
        $manager = Get-ADUser $user.Manager -Properties EmailAddress
        $html = $header + ($htmlTemplate -f $manager.GivenName,$tableInfo)
        $EmailParams = @{
            To = $manager.EmailAddress
            From = $from
            Subject = 'Account Expiration Notification'
            Body = $html
            BodyAsHtml = $true
            UseSSL = $true
            SmtpServer = 'smtp.office365.com'
            Credential = $EmailCredential
        }
        Send-MailMessage @EmailParams
    }
}

# Usage
Send-ADAccountExpirations -DaysTillExpiration 14 -From $cred.UserName

#endregion