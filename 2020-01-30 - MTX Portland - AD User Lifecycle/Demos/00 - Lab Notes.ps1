Function New-LabSessions {
    Param (
        [string[]]$Comps = 'DC01',
        [string]$Domain = 'techsnipsdemo.org',
        [string]$Password = 'Password2!'
    )
    $global:Sessions = @()
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Cred = [pscredential]::new("$Domain\administrator",$securePassword)
    ForEach($Comp in $Comps){
        $global:Sessions += New-PSSession $comp -Credential $cred
    }
}

$PSVersionTable

New-LabSessions
Enter-PSSession $Sessions[0]