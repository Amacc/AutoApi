#Requires -Modules @{ ModuleName='PS-AutoApi'; ModuleVersion='1.0.11' }

try{
    Import-Module PS-AutoApi

    Write-Host "Debug Log:LambdaInput=$($LambdaInput | out-string)"
    Write-Host "Debug Log:LambdaInput.PATH=$($LambdaInput.Path)"
    $RegisteredRoutes = Get-RegisteredRoutes
    if ($RegisteredRoutes.Length -eq 0){
        Write-Host "No Registered Routes"
    }
    @(
        [PSCustomObject]@{
            Name="add"
            Route ="add/{first}/{second}"
            ScriptBlock = {
                param($first,$second)
                Write-Host "First:$First"
                Write-Host "Second:$Second"
                return [double]$first + [double]$second
            }
        },
        [PSCustomObject]@{
            Route ="sub/{first}/{second}"
            Name="sub"
            ScriptBlock= { [double]$tokens[1]  - [double]$tokens[2] }
        },
        [PSCustomObject]@{
            Route ="mul/{first}/{second}"
            Name="mul"
            ScriptBlock= { [double]$tokens[1]  * [double]$tokens[2]}
        },
        [PSCustomObject]@{
            Route ="div/{first}/{second}"
            Name="div"
            ScriptBlock= { [double]$tokens[1]  / [double]$tokens[2]}
    }) | Register-Route

    # IF There is no lambda input then this
    #    is dot sourced to read registered paths
    if($LambdaInput){
        Write-Host "Debug Log:LambdaInput Found"
        Write-Host "Debug Log:LambdaInput:Type:$($LambdaInput.GetType())"
        Write-Host "Debug Log:RegisteredRoutes:$(Get-RegisteredRoutes)"
        Write-Host "$(Get-RegisteredRoutes)"

        $FoundRoute = Get-RegisteredRoutes |
            Where-Object { $_.Route -like $LambdaInput.resource  }

        Write-Host "Debug Log:FoundRoute:$( $FoundRoute | Out-String )"

        return @{
            'statusCode' = 200;
            'body' = $LambdaInput | Invoke-Path | Out-String
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
