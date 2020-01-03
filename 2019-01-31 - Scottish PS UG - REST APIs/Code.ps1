#region demo header
Throw 'this is a demo'
#endregion
# cURL vs Invoke-RestMethod

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#region Airtable GET example
Invoke-RestMethod -Uri https://api.airtable.com/v0/appBLvHFF78kERCvW/Payees -Headers @{
    Authorization = "Bearer $AirTableKey"
}
# Get more info
$resp = Invoke-RestMethod -Uri https://api.airtable.com/v0/appBLvHFF78kERCvW/Payees -Headers @{
    Authorization = "Bearer $AirTableKey"
}
$resp.records
#endregion

#region PDF Generator GET Example
$header = @{
    'X-Auth-Key' = $PDF.key
    'X-Auth-Secret' = $PDF.secret
    'X-Auth-Workspace' = $PDF.workspace
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
}
Invoke-RestMethod -Uri 'https://us1.pdfgeneratorapi.com/api/v3/templates' -Headers $header
# Get more info
$resp = Invoke-RestMethod -Uri 'https://us1.pdfgeneratorapi.com/api/v3/templates' -Headers $header
$resp.response
#endregion

#region SherpaDesk GET example:
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($sd.WorkingOrganization)`-$($sd.WorkingInstance)`:$($sd.apikey)"))
$header = @{
    Authorization = "Basic $encodedAuth"
    Accept = 'application/json'
}
Invoke-RestMethod -Uri 'https://api.sherpadesk.com/tickets?status=open,onhold&role=user&limit=6&format=json' -Headers $header
#endregion

#region Airtable PATCH example
# Get
Invoke-RestMethod 'https://api.airtable.com/v0/appBLvHFF78kERCvW/Payees/recMvdJuoL6ivDA9I' -Method Get -Headers $headers
$resp = Invoke-RestMethod 'https://api.airtable.com/v0/appBLvHFF78kERCvW/Payees/recMvdJuoL6ivDA9I' -Method Get -Headers $headers
$resp.fields
# Patch
$headers = @{
    Authorization = "Bearer $AirTableKey"
    'Content-Type' = 'application/json'
    Accept = 'application/json'
}
$body = @{
    fields = @{
        Name = 'EWEB'
    }
} | ConvertTo-Json
Invoke-RestMethod 'https://api.airtable.com/v0/appBLvHFF78kERCvW/Payees/recMvdJuoL6ivDA9I' -Method Patch -Headers $headers -Body $body
#endregion

#region PDF Generator POST example
$header = @{
    'X-Auth-Key' = $PDF.key
    'X-Auth-Secret' = $PDF.secret
    'X-Auth-Workspace' = $PDF.workspace
    "Content-Type" = "application/json"
    "Accept" = "application/json"
}
$body = @{
    id = 304355781
    DocNumber = 15
    ShipAddr = @{  
        Line1 = "St Patrick Road 4"
        City = "London"
        Country = "United Kingdom"
        CountrySubDivisionCode = "UK12991"
   }
   CustomerInfo = @{
       CompanyName = 'Acme Inc.'
       GivenName = "John"
       FamilyName = 'Smith'
   }
   CompanyInfo = @{
       CompanyName = 'Your Fav Shipper!'
   }
   Line = @(
       @{
            Name = "#1014A"
            Description = "Customer Notes"
       }
   )
} | ConvertTo-Json
Invoke-RestMethod -Uri 'https://us1.pdfgeneratorapi.com/api/v3/templates/21661/output?format=pdf&output=base64' -Method Post -Headers $header -Body $Body

#region Convert to file
$resp = Invoke-RestMethod -Uri 'https://us1.pdfgeneratorapi.com/api/v3/templates/21661/output?format=pdf&output=base64' -Method Post -Headers $header -Body $Body
$bytes = [Convert]::FromBase64String($resp.response)
[IO.File]::WriteAllBytes('C:\tmp\PDFGenExample.pdf', $bytes)
. 'C:\tmp\PDFGenExample.pdf'
#endregion
#endregion

#region SherpaDesk Put example
# Get
(Invoke-RestMethod -Uri "https://api.sherpadesk.com/time" -Headers $header) | ?{$_.time_id -eq '2292188'}
# Put
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$($sd.WorkingOrganization)`-$($sd.WorkingInstance)`:$($sd.apikey)"))
$header = @{
    Authorization = "Basic $encodedAuth"
    Accept = 'application/json'
    'Content-Type' = 'application/json'
}
$body = @{
    account_id = '-1'
    hours = '2.00'
    is_project_log = 'false'
    note_text = 'test_30/01_31/01_BLAHBLAH'
    task_type_id = '94604'
    tech_id ='950330'
} | ConvertTo-Json
Invoke-RestMethod -Uri "https://api.sherpadesk.com/time/2292188?format=json" -Method Put -Headers $header -Body $body
#endregion

#region SherpaDesk retrieve API key
$credential = Get-Credential
$up = "$($credential.GetNetworkCredential().UserName)`:$($credential.GetNetworkCredential().Password)"
$encodedUP = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$up"))
$header = @{
    Authorization = "Basic $encodedUP"
    Accept = 'application/json'
}
$resp = Invoke-RestMethod -Method Get -Uri 'https://api.sherpadesk.com/login' -Headers $header
$Script:AuthConfig = @{
    ApiKey = $resp.api_token
    WorkingOrganization = ''
    WorkingInstance = ''
}
#endregion

#region SherpaDesk metadata
$encodedAuth = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("x:$($AuthConfig.ApiKey)"))
$header = @{
    Authorization = "Basic $encodedAuth"
    Accept = 'application/json'
}
$resp = Invoke-RestMethod -Uri 'https://api.sherpadesk.com/organizations/' -Method Get -Headers $header
$Script:AuthConfig.WorkingOrganization = $resp[0].key
$Script:AuthConfig.WorkingInstance = $resp[0].instances[0].key
#endregion