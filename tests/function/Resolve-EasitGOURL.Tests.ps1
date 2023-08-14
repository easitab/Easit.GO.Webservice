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
}
Describe "Resolve-EasitGOURL" -Tag 'function','private' {
    It 'should have a parameter named URL that is mandatory and accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter URL -Mandatory -Type String
    }
    It 'should have a parameter named Endpoint that is mandatory and accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Endpoint -Mandatory -Type String
    }
    It 'should add "/integration-api/ping"' {
        Resolve-EasitGOURL -URL 'https://test.easit.com' -Endpoint 'ping' | Should -BeExactly 'https://test.easit.com/integration-api/ping'
    }
    It 'should add "integration-api/ping"' {
        Resolve-EasitGOURL -URL 'https://test.easit.com/' -Endpoint 'ping' | Should -BeExactly 'https://test.easit.com/integration-api/ping'
    }
    It 'should add "/ping"' {
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api' -Endpoint 'ping' | Should -BeExactly 'https://test.easit.com/integration-api/ping'
    }
    It 'should add "ping"' {
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/' -Endpoint 'ping' | Should -BeExactly 'https://test.easit.com/integration-api/ping'
    }
    It 'should be same' {
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/ping' -Endpoint 'ping' | Should -BeExactly 'https://test.easit.com/integration-api/ping'
    }
    It 'should have SYNOPSIS' {
        ((Get-Help "$($envSettings.CommandName)" -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'should have DESCRIPTION' {
        ((Get-Help "$($envSettings.CommandName)" -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'should have EXAMPLES' {
        ((Get-Help "$($envSettings.CommandName)" -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
}