# Using a Sherpa Desk example:
# curl --request GET 'https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json'

## Name?
Get-SherpaDeskTicket
Get-SDTicket

## Parameters
[string]$Organization
[string]$Instance
[string]$ApiKey # This could be a secure string: [System.Security.SecureString]
[string[]]$Status
[string]$Role
[int]$Limit
[string]$Format = 'json'

## Build the headers
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$Organization-$Instance`:$ApiKey"))
$headers = @{
    Authorization = "Basic $encodedAuth"
    Accept = 'application/json'
}

## Build the query string
$queryParamNames = 'Status','Role','Limit','Format'
$queryArr = foreach ($param in ($PSBoundParameters.Keys | Where-Object {$queryParamNames -contains $_})) {
    "$param=$($PSBoundParameters[$param] -join ',')"
}

## Building the URI
$baseUri = 'https://api.sherpadesk.com'
$resource = 'tickets'
$query = ($queryArr -join '&').ToLower()

$uri = "$baseUri/$resource`?$query"

## Making the call
Invoke-RestMethod -Uri $uri -Method Get

## Combine everything
Function Get-SDTicket {
    [CmdletBinding()]
    param (
        [string]$Organization,
        [string]$Instance,
        [string]$ApiKey, # This could be a secure string: [System.Security.SecureString]
        [string[]]$Status,
        [string]$Role,
        [int]$Limit,
        [string]$Format = 'json'
    )
    ## Build the headers
    $encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$Organization-$Instance`:$ApiKey"))
    $headers = @{
        Authorization = "Basic $encodedAuth"
        Accept = 'application/json'
    }

    ## Build the query string
    $queryParamNames = 'Status','Role','Limit','Format'
    $queryArr = foreach ($param in ($PSBoundParameters.Keys | Where-Object {$queryParamNames -contains $_})) {
        "$param=$($PSBoundParameters[$param] -join ',')"
    }

    ## Building the URI
    $baseUri = 'https://api.sherpadesk.com'
    $resource = 'tickets'
    $query = ($queryArr -join '&').ToLower()

    $uri = "$baseUri/$resource`?$query"

    ## Making the call
    Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
}

# Run it
$auth = Get-Content C:\users\AnthonyHowell\Documents\sd.txt | ConvertFrom-Json
$sdTicketParams = @{
    Organization = $auth.organization
    Instance = $auth.instance
    ApiKey = $auth.password
    Status = 'open','onhold'
    Role = 'user'
    Limit = 6
    Format = 'json'
}
Get-SDTicket @sdTicketParams -Verbose