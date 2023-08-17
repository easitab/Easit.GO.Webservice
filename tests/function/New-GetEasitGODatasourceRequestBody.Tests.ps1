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
    function Convert-ToEasitGOJson {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$InputObject,
            [Parameter()]
            [System.Collections.Hashtable]$Parameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceRequest.json') -Raw
    }
}
Describe "New-GetEasitGODatasourceRequestBody" {
    It 'should have a parameter named ModuleId that is mandatory and accepts an integer.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ModuleId -Mandatory -Type int
    }
    It 'should have a parameter named ParentRawValue that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ParentRawValue -Type string
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
    It 'should not throw with only ModuleId provided' {
        {New-GetEasitGODatasourceRequestBody -ModuleId 1002} | Should -Not -Throw
    }
    It 'should not throw with ModuleId and ParentRawValue provided' {
        {New-GetEasitGODatasourceRequestBody -ModuleId 1002 -ParentRawValue '5:1'} | Should -Not -Throw
    }
    It 'output should be convertable from JSON' {
        {New-GetEasitGODatasourceRequestBody -ModuleId 1002 | ConvertFrom-Json} | Should -Not -Throw
    }
    It 'converted output should a property called moduleId and it should not be null or empty' {
        $output = New-GetEasitGODatasourceRequestBody -ModuleId 1002 | ConvertFrom-Json
        $output.moduleId | Should -Not -BeNullOrEmpty
    }
    It 'converted output should a property called parentRawValue and it should not be null or empty' {
        $output = New-GetEasitGODatasourceRequestBody -ModuleId 1002 -ParentRawValue '5:1' | ConvertFrom-Json
        $output.parentRawValue | Should -Not -BeNullOrEmpty
    }
}