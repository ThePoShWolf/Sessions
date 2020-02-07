#region Create a template
# Create a new manifest using New-PlasterManifest

## Make sure we are in the right spot
Set-Location 'C:\users\anthony\git\sessions\2020-02-10 - Mississippi PS UG - Module Building Modules\Demos'
function prompt{}

## Splat the required parameters
## Pulled from Mike F Robbins: https://mikefrobbins.com/2018/02/15/using-plaster-to-create-a-powershell-script-module-template/
$manifestProperties = @{
    Path         = '.\Template\PlasterManifest.xml'
    TemplateName = 'ScriptModuleTemplate'
    TemplateType = 'Project' # or Item. Modules are projects though
    Author       = 'Anthony Howell'
    Description  = 'Scaffolds the files required for a PowerShell script module'
    Tags         = 'PowerShell, Module, ModuleManifest'
}
New-PlasterManifest @manifestProperties

## Now we can look at the file:
.\Template\PlasterManifest.xml

## And we can test it:
Invoke-Plaster -TemplatePath .\Template -DestinationPath .\TestModule

## And clean up
Remove-Item .\TestModule

#endregion

#region Add stuff to the Plaster manifest
# Add parameters
@'
<parameter
      name='ModuleName'
      type='text'
      prompt='Name of the module' 
    />
    <parameter
      name='Description'
      type='text'
      prompt='Brief description of module (required for publishing to the PowerShell Gallery)'
    />
    <parameter
      name='Version'
      type='text'
      default='0.0.1'
      prompt='Enter the version number of the module'
    />
    <parameter
      name='Author'
      type='user-fullname'
      prompt="Module author's name"
      store='text'
    />
    <parameter
      name='CompanyName'
      type='text'
      prompt='Name of your Company'
      default='Howell IT, LLC'
    />
    <parameter
      name='PowerShellVersion'
      default='6.0'
      type='text'
      prompt='Minimum PowerShell version'
    />
'@ | clip

# Add content

@'
<message>
      Creating folder structure
    </message>
    <file
      source=''
      destination='build'
    />
    <file
      source=''
      destination='docs'
    />
    <file
      source=''
      destination='src'
    />
    <file
      source=''
      destination='src\private'
    />
    <file
      source=''
      destination='src\public'
    />
    <file
      source=''
      destination='tests'
    />
    <message>
      Deploying common files
    </message>
    <file
      source='Module.Build.ps1'
      destination='${PLASTER_PARAM_ModuleName}.Build.ps1'
    />
    <file
      source='Module.Deploy.ps1'
      destination='${PLASTER_PARAM_ModuleName}.Deploy.ps1'
    />
    <file
      source='onload.ps1'
      destination='src\onload.ps1'
    />
    <file
      source='using.ps1'
      destination='src\using.ps1'
    />
    <message>
      Creating Module Manifest
    </message>
    <newModuleManifest
      destination='src\${PLASTER_PARAM_ModuleName}.psd1'
      moduleVersion='$PLASTER_PARAM_Version'
      rootModule='${PLASTER_PARAM_ModuleName}.psm1'
      author='$PLASTER_PARAM_Author'
      companyName='$PLASTER_PARAM_CompanyName'
      description='$PLASTER_PARAM_Description'
      powerShellVersion='$PLASTER_PARAM_PowerShellVersion'
      encoding='UTF8-NoBOM'
    />
'@ | clip

# Copy template files
# These files are also in my MyPlasterTemplates repo: https://github.com/ThePoShWolf/MyPlasterTemplates/tree/master/ScriptModule
Get-ChildItem 'C:\users\anthony\git\MyPlasterTemplates\ScriptModule' -Filter *.ps1 | %{Copy-Item $_.FullName -Destination .\Template}

#endregion

# Test it
Invoke-Plaster -TemplatePath .\Template -DestinationPath ..\..\..\DemoRepo

# Verify
Code ..\..\..\DemoRepo