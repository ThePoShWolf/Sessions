# Research Triangle PowerShell User Group 2022-01-05

## Presentation

Relevant links:
- Runway website: https://runway.host
- Runway Documentation: https://docs.runway.host
- Runway Portal: https://portal.runway.host
- Runway Actions repository: https://github.com/runway-software/actions
- Runway PowerShell SDK:
  - Github: https://github.com/runway-software/runway-powershell
  - PowerShell Gallery: https://www.powershellgallery.com/packages/PsRunway

### What is Runway?

Runway is a service orchestration and automation platform. At its core, it runs arbitrary code (scripts, executables, etc) on endpoints.

Runway is:
- An automation platform
- REST API Driven
  - Web based Portal, compiled executable, PowerShell SDK

Runway can:
- Run arbitrary code on endpoints via installed agents (Runners)
  - Including PowerShell! Both Windows PowerShell and PowerShell, even if PowerShell isn't installed
- Schedule jobs
- Run asset discovery on networks
- Self deploy in AD environments

![Platform Overview](assets/platformoverview.png)

## Enrolling a runner

You can get a token from the Portal.

Or use the SDK:

```powershell
# Get a token, associate it to a specific group
# Runway will default to your root group
$group = (Get-RwGroup).Items | ?{$_.Name -eq 'Home'}
$tokenSplat = @{
    Expiration = (Get-Date).AddHours(1)
    IsOneTime = $true
    GroupId = $group.Id
    Type = 'EnrollPersistentRunner'
}
$token = New-RwEnrollmentSession @tokenSplat

# Use the utility to install the Runner:
.\runway install -t $token.Token
```