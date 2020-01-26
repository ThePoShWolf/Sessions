# Getting items from Airtable
$token = Get-Content C:\users\AnthonyHowell\Documents\at.txt
## curl
# link: https://airtable.com/appTczXUIAllL0x88/api/docs#curl/table:work%20items:list
# this link is specific to an Airtable 'base'. This is using a template base.
curl https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items -H "Authorization: Bearer YOUR_API_KEY"

## PowerShell
$headers = @{
    Authorization = "Bearer $token"
}
Invoke-RestMethod -Uri 'https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items' -Headers $headers

# Creating items in Airtable
## curl
# link: https://airtable.com/appTczXUIAllL0x88/api/docs#curl/table:clients:create
curl -v -X POST https://api.airtable.com/v0/appTczXUIAllL0x88/Clients \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  --data '{
  "records": [
    {
      "fields": {
        "Work Items": [
          "reczyGwJ6AiXVq9TA"
        ],
        "Name": "South Lake Store"
      }
    },
    {
      "fields": {
        "Work Items": [
          "reczwzBP3ygLPraYu",
          "recFFxoFVGrMPtbSE",
          "recGKApP4vqYZpeZI"
        ],
        "Name": "Marina Shop"
      }
    }
  ]
}'

## PowerShell
$headers = @{
    Authorization = "Bearer $token"
    'Content-Type' = 'application/json'
}

$body = @{
    records = @(
        fields = @{
            workitems = @("reczwzBP3ygLPraYu","recFFxoFVGrMPtbSE","recGKApP4vqYZpeZI")
            Name = 'Marina Shop'
        },
        @{
            workitems = @("reczyGwJ6AiXVq9TA")
            Name = 'South Lake Store'
        }
    )
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri 'https://api.airtable.com/v0/appTczXUIAllL0x88/Clients' -Headers $headers -Body $body

# Basic Authentication
# link: https://documenter.getpostman.com/view/4454237/apisherpadeskcom-playground/RW8AooQg?version=latest#6a1f8cfa-8910-8c9f-2e68-bfaefb51920b

## curl
curl --request GET 'https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json'

## PowerShell
$auth = Get-Content C:\users\AnthonyHowell\Documents\sd.txt | ConvertFrom-Json
# using their values
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes('ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf'))
# using actual values
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($auth.username):$($auth.password)"))
$headers = @{
    Authorization = "Basic $encodedAuth"
    Accept = 'application/json'
}
Invoke-RestMethod -Uri 'https://api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json' -Headers $headers

# Curl2PS
## curl man pages: https://curl.haxx.se/docs/manpage.html

## Import dev version
Import-Module ..\Curl2PS\build\Curl2PS

## Convert
ConvertTo-IRM 'curl https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items -H "Authorization: Bearer YOUR_API_KEY"' -String

ConvertTo-IRM "curl --request GET 'https://ncg1in-8d1rag:5nuauzj5pkfftlz3fmyksmyhat6j35kf@api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json'" -String