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
Describe "Convert-GetItemsResponse" {
    It 'should have a parameter named Response that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Response -Mandatory -Type PSCustomObject
    }
    It 'should have a parameter named ThrottleLimit' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ThrottleLimit
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help 'Convert-GetItemsResponse' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'Convert-GetItemsResponse' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'Convert-GetItemsResponse' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
}