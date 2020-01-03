    # Quick Curl2PS examples

# Example docs

# Here are some examples of API docs that use curl (non-exhaustive):

<#
- [Trello API](https://developers.trello.com/reference)
- [PDF Generator API](https://docs.pdfgeneratorapi.com)
- [Slack API](https://api.slack.com/web)
- [Airtable](https://airtable.com/api)
- [SherpaDesk](https://documenter.getpostman.com/view/4454237/apisherpadeskcom-playground/RW8AooQg)
#>

# Import Module
Import-Module C:\users\Anthony\GIT\Curl2PS\build\Curl2PS\Curl2PS.psd1

# Cmdlets
Get-Command -Module Curl2PS

# Example calls

<#
curl --request GET "https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json"
#>

$curlStr = 'curl --request GET "https://tkldsi-sgq3yh:pb5sd018hjapuzphcy6tc58g2ulqeque@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json"'
$irmStr = ConvertTo-IRM $curlStr
$irmStr
Invoke-Command ([scriptblock]::Create($irmStr))

# Terrible Output
# Lets tell the API we want json

<#
curl --request GET -H "Accept: application/json" "https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json"
#>

$curlStr = 'curl --request GET -H "Accept: application/json" "https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json"'
$irmStr = ConvertTo-IRM $curlStr
$irmStr
Invoke-Command ([scriptblock]::Create($irmStr))