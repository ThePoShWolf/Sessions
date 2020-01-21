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

$baseUri = 'https://api.stackexchange.com/2.2/'

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

help Invoke-RestMethod -Parameter Method

# Body



#endregion

#region Headers
# Common

# Custom

#endregion

#region Authentication
# v5.1 in the headers

# v6+ -Authentication

#endregion