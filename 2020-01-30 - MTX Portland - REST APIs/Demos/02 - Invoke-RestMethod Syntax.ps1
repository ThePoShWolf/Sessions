#region Common
# URI
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

# Method

## Basic:
Invoke-RestMethod -Method 'Post' -Uri 'SomeUri'

# Common Headers

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
Invoke-RestMethod -ContentType 'application/json'

## Post a user to Octopus
$apiKey = 'API-9M1UYY2H8ZRBJIN7CG4MNJLEA7A' # never save api tokens in plain text
$baseUri = 'http://192.168.11.8/api'
$resource = 'users'

$htBody = @{
    Username = 'NewUser'
    DisplayName = 'New User'
    Password = 'Password1234!'
}

$jsonBody = $htBody | ConvertTo-Json

$headers = @{
    'X-Octopus-ApiKey' = $apiKey
    'Content-Type' = 'application/json'
}

Invoke-RestMethod $baseUri/$resource -Method Post -Headers $headers -Body $jsonBody

#endregion

#region Authentication
# v5.1 in the headers

# v6+ -Authentication

#endregion