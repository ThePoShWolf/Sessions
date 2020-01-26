#region Common
#region URI
## Uri breakdown

<#
'https://api.howell-it.com:8080/projects?name=UrlStuff&count=2'

    https://               - protocol
    api                    - subdomain
    howell-it              - domain
    com                    - top-level domain
    8080                   - port
    project                - path (or resource)
    ?                      - what follows after this is the query
    name=UrlStuff&count=2  - parameters.
#>

## Basic uri
Invoke-RestMethod -Uri 'http://xkcd.com/info.0.json'

## Uri with query parameters
Invoke-RestMethod -Uri 'https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow'

### Breakdown

$baseUri = 'https://api.stackexchange.com/2.2'

$resource = 'answers'

$queries = @(
    'order=desc'
    'sort=activity'
    'site=stackoverflow'
) -join '&'

$uri = "$baseUri/$resource`?$queries"

$uri

Invoke-RestMethod -Uri $uri
#endregion

# Method

## Basic:
Invoke-RestMethod -Method 'Post' -Uri 'SomeUri'

#region Common Headers

## v5.1
$headers = @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}

Invoke-RestMethod -Headers $headers

## v6+
$headers = @{
    'Accept' = 'application/json'
}
Invoke-RestMethod -ContentType 'application/json' -Headers $headers

## Post a user to Octopus
$apiKey = 'API-9M1UYY2H8ZRBJIN7CG4MNJLEA7A'
#never save api tokens in plain text
#this is for a demo server

$baseUri = 'http://192.168.11.8/api'
$resource = 'users'

$htBody = @{
    Username = 'NewUser1'
    DisplayName = 'New User'
    Password = 'Password1234!'
}

$jsonBody = $htBody | ConvertTo-Json

$headers = @{
    'X-Octopus-ApiKey' = $apiKey
    'Content-Type' = 'application/json'
}

Invoke-RestMethod -Uri $baseUri/$resource -Method Post -Headers $headers -Body $jsonBody

## Now get that user

Invoke-RestMethod $baseUri/$resource -Method Get -Headers $headers

(Invoke-RestMethod $baseUri/$resource -Method Get -Headers $headers).Items
#endregion
#endregion

#region Authentication
## Basic Auth
## example source: https://docs.microsoft.com/en-us/rest/api/azure/devops/build/builds/list?view=azure-devops-rest-5.1

### v5.1 in the headers
$apiKey = Get-Content C:\Users\AnthonyHowell\Documents\azdo.txt

$base64Auth = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(("username:$apiKey")))

$headers = @{
    Authorization = "Basic $base64Auth"
    Accept = "application/json; api-version=5.1"
    'Content-Type' = 'application/json'
}

Invoke-RestMethod -Uri 'https://dev.azure.com/theposhwolf/curl2ps/_apis/build/builds' -Headers $headers

### v6+ -Authentication
$securePassword = ConvertTo-SecureString $apiKey -AsPlainText -Force
$cred = [pscredential]::new('username',$securePassword)
$params = @{
    URI = 'https://dev.azure.com/theposhwolf/curl2ps/_apis/build/builds'
    Headers = $headers
    Authentication = 'Basic'
    Credential = $cred
}
Invoke-RestMethod @params

## OAuth (bearer token)

### v5.1
$token = Get-Content C:\users\AnthonyHowell\Documents\at.txt
$headers = @{
    Authorization = "Bearer $token"
    Accept = 'application/json'
}
Invoke-RestMethod -Uri 'https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items' -Headers $headers

### v6
$token = Get-Content C:\users\AnthonyHowell\Documents\at.txt
$secureToken = ConvertTo-SecureString $token -AsPlainText -Force
$params = @{
    Uri = 'https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items'
    Authentication = 'OAuth'
    Token = $secureToken
}
Invoke-RestMethod @params

#endregion