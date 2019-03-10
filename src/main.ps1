#Requires -Modules @{ ModuleName='PS-AutoApi'; ModuleVersion='1.0' }

try{
    Import-Module PS-AutoApi

    Write-Host "Debug Log:"
    Write-Host "Debug Log:LambdaInput=$($LambdaInput | out-string)"
    Write-Host "Debug Log:LambdaInput.PATH=$($LambdaInput.Path)"

    @(
        [PSCustomObject]@{
            Name="Add"
            Route ="add/{first}/{second}"
            ScriptBlock= { [double]$tokens[1]  + [double]$tokens[2] }
        },
        [PSCustomObject]@{
            Route ="sub/{first}/{second}"
            Name="Sub"
            ScriptBlock= { [double]$tokens[1]  - [double]$tokens[2] }
        },
        [PSCustomObject]@{
            Route ="mul/{first}/{second}"
            Name="Mul"
            ScriptBlock= { [double]$tokens[1]  * [double]$tokens[2]}
        },
        [PSCustomObject]@{
            Route ="div/{first}/{second}"
            Name="Div"
            ScriptBlock= { [double]$tokens[1]  / [double]$tokens[2]}
    }) | Register-Route

    #IF There is no lambda input then this
    # is dot sourced to read registered paths
    if($LambdaInput){
        return @{
            'statusCode' = 200;
            'body' = [PSCustomObject]$LambdaInput |
                Invoke-Path |
                Out-String
                # ConvertTo-Json
            'headers' = @{'Content-Type' = 'text/plain'}
            # 'headers' = @{'Content-Type' = 'application/json'}
        }
    }
}
catch {
    return @{
        'statusCode' = 500;
        'body' = $_ | Out-String
        'headers' = @{'Content-Type' = 'text/plain'}
    }
}
