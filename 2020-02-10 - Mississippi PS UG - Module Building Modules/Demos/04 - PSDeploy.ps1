# Show the PSDeploy file
code .\TestModule.PSDeploy.ps1

#region
# List out the deployment:
Get-PSDeployment -Path .\TestModule.PSDeploy.ps1

# Make sure our build is up to date
Invoke-Build -Task Publish

# Deploy
# Since we are in the root folder, no path is necessary
# It finds all files *.psdeploy.ps1
Invoke-PSDeploy -Force

# Use our build script to do EVERYTHING
Invoke-Build -Take Publish

#endregion