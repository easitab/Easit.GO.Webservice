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
    function Get-BaseRestMethodParameter {
        param (
            [Parameter()]
            [Switch]$Ping
        )
        return [System.Collections.Hashtable]@{
            Url = 'https://url.to.EasitGO'
            Method = 'Get'
            ContentType = 'application/json'
        }
    }
    function Resolve-EasitGOUrl {
        param (
            [Parameter()]
            [String]$URL,
            [Parameter()]
            [String]$Endpoint
        )
        return 'https://url.to.EasitGO/integration-api/datasources/'
    }
    function Invoke-EasitGOWebRequest {
        param (
            [Parameter()]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters
        )
        '{"message": "Pong!"}' | ConvertFrom-Json
    }
}
Describe "Test-EasitGOConnection" -Tag 'function','public' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type 'String'
    }
    It 'should have a parameter named InvokeRestMethodParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InvokeRestMethodParameters -Type 'hashtable'
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
    It 'should not throw when providing valid url' {
        {Test-EasitGOConnection -URL 'https://test.easit.com'} | Should -Not -Throw
    }
}