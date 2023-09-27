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
    $getIccUrlParams = @{
        Url = 'https://go.easit.com'
        Query = 'apikey=myApikey&identifier=importClientConfigurationName'
    }
}
Describe "Get-EasitGOIccUrl" -Tag 'function','private' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type [String]
    }
    It 'should have a parameter named Query that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Query -Type [String]
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
    It 'should not throw' {
        {Get-EasitGOIccUrl @getIccUrlParams} | Should -Not -Throw
    }
    It 'should return a string with a length of 25 when only URL is provided' {
        (Get-EasitGOIccUrl -Url $getIccUrlParams.URL).Length | Should -BeExactly 25
    }
    It 'should return a string with a length of 82 when both URL and Query is provided' {
        (Get-EasitGOIccUrl @getIccUrlParams).Length | Should -BeExactly 82
    }
}