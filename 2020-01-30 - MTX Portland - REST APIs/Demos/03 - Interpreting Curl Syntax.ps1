# Getting items from Airtable
$token = Get-Content C:\users\AnthonyHowell\Documents\at.txt
## curl
curl https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items -H "Authorization: Bearer YOUR_API_KEY"

## PowerShell
$headers = @{
    Authorization = "Bearer $token"
}
Invoke-RestMethod -Uri 'https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items' -Headers $headers

# Creating items in Airtable
## curl
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

Invoke-RestMethod -Uri 'https://api.airtable.com/v0/appTczXUIAllL0x88/Clients' -Headers $headers -Body $body

# Curl2PS
## Import dev version
Import-Module ..\Curl2PS\build\Curl2PS

## Convert
ConvertTo-IRM 'curl https://api.airtable.com/v0/appTczXUIAllL0x88/Work%20Items -H "Authorization: Bearer YOUR_API_KEY"' -String