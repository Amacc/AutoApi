# Remove-Module WebApi
# Import-Module .\src\WebApi\WebApi.psm1

Clear-Routes

Write-Host "Importing Paths"
. ./src/main.ps1

@{ Routes= Get-RegisteredRoutes} |
    ConvertTo-Json |
    j2 --format=json serverless-template.yml -o build/serverless.yml
