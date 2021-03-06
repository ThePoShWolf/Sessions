<#
    How to user regular expressions in PowerShell
#>

#region -Match

$emailAddress = 'anthony@howell-it.com'

# pattern from: https://regular-expressions.mobi/email.html
$pattern = "^[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$"

if ($emailAddress -match $pattern) {
    Write-Host 'You have an email address :)'
} else {
    Write-Host 'That is not an email address :('
}

#endregion

#region -Replace

$str = 'My phone number is: 1234567890'
$str -replace '(\d\d\d)(\d\d\d)(\d\d\d\d)','($1)-$2-$3'

# Advanced version
$str -replace '(\(?\d{3}\)?)-?(\d{3})-?(\d{4})','($1)-$2-$3'

#endregion

#region Select-String

Get-Content '.\2021-04-29 - PowerShell Summit 2021 - Practically Regexing\Demos\SampleLog.txt' | Select-String '\[error\]'

#endregion

#region switch -regex

$str = 'My email is anthony@howell-it.com and my phone number is 1234567890'
switch -regex ($str) {
    "[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?" {
        Write-Host 'There is an email!'
    }
    '(\(?\d{3}\)?)-?(\d{3})-?(\d{4})' {
        Write-Host 'There is a phone number!'
    }
}

#endregion

#region [ValidatePattern()]

Function Get-EmailAddress {
    param (
        [ValidatePattern(
            "^[a-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$"
        )]
        [string]$EmailAddress
    )
    Write-Output $EmailAddress
}
Get-EmailAddress 'blahdeblah'
Get-EmailAddress 'anthony@howell-it.com'

#endregion