#Perform Setup
Install-Module PS-AutoApi -Force
Import-Module PS-AutoApi

$PSScriptRoot\setup.j2.ps1

Clear-Routes

Write-Host "Importing Paths"
. ./src/main.ps1

@{ Routes= Get-RegisteredRoutes} |
    ConvertTo-Json |
    j2 --format=json serverless-template.yml -o build/serverless.yml


If($Error.Count -gt 0){ Exit 1 }
