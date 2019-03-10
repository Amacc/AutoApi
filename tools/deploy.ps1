[cmdletbinding()]param(
    [switch]$BuildOnly,
    [switch]$SkipPackageStep,
    [switch]$SkipPushToS3,
    $MainScript
)
begin{
    Install-Module AWSLambdaPSCore -Force
    Import-Module AWSLambdaPSCore

    . $PSScriptRoot\utils.ps1

    Write-Host (Get-Content build/serverless.yml -Raw)
    Write-Host (Get-ChildItem build)
    $package = Get-Content -raw package.json | ConvertFrom-Json
    $stackName = $package.name
    $bucketName = $package.autoapi.$bucket
    $Dependencies = $package.autoapi.includes
}
end{
    Write-Host "Deploying $stackName"
    if(-not $SkipPackageStep){
        Write-Verbose "Building Lambda Package"
        New-AWSPowerShellLambdaPackage -ScriptPath ./src/main.ps1 `
            -OutputPackage build/$stackName.zip


        Compress-Archive -path ./src/* `
            -Update -DestinationPath build/$stackName.zip


        if(-not $SkipPushToS3){
            #TODO: Note update serverless template code uri with Symbol replacement
            aws cloudformation package `
                --template-file build/serverless.yml `
                --s3-bucket $bucketName `
                --output-template-file build/updated.template
        }
    }
    if(-not $BuildOnly){
        aws cloudformation deploy `
            --template-file build/updated.template `
            --stack-name $stackName `
            --capabilities CAPABILITY_IAM
    }
    If($Error.Count -gt 0){ Exit 1 }
}
