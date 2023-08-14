BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
    try {
        $response = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceResponse.json') -Raw | ConvertFrom-Json
        $output = Convert-EasitGODatasourceResponse -Response $response
        $emptyResponse = [PSCustomObject]@{datasource=@()}
    } catch {
        throw $_
    }
}
Describe "Convert-EasitGODatasourceResponse" {
    It 'should have a parameter named Response that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Response -Mandatory -Type PSCustomObject
    }
    It 'should have a parameter named ThrottleLimit' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ThrottleLimit
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help "$($envSettings.CommandName)" -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help "$($envSettings.CommandName)" -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help "$($envSettings.CommandName)" -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should not throw with valid input' {
        {Convert-EasitGODatasourceResponse -Response $response} | Should -Not -Throw
    }
    It 'should throw if input is null' {
        {Convert-EasitGODatasourceResponse -Response $null} | Should -Throw
    }
    It 'should return null or empty if input does not contain any datasources' {
        Convert-EasitGODatasourceResponse -Response $emptyResponse -WarningAction 'SilentlyContinue' | Should -BeNullOrEmpty
    }
    It 'should return 4 objects' {
        $output.Count | Should -BeExactly 4
    }
    It 'a returned object should have a name property with a value' {
        $output[0].name | Should -Not -BeNullOrEmpty
    }
    It 'a returned object should have a name rawValue with a value' {
        $output[0].rawValue | Should -Not -BeNullOrEmpty
    }
}