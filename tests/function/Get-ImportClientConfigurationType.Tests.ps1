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
    $ldapXml = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'ldapConfiguration.xml') -Raw
    $jdbcXml = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'jdbcConfiguration.xml') -Raw
    $fileXml = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'fileConfiguration.xml') -Raw
    $unknownXml = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'unknownConfiguration.xml') -Raw
}
Describe "Get-ImportClientConfigurationType" -Tag 'function','private' {
    It 'should have a parameter named Configuration that accepts a XmlDocument' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Configuration -Type [System.Xml.XmlDocument]
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
    It 'should return a string' {
        Get-ImportClientConfigurationType -Configuration $ldapXml | Should -BeOfType [System.String]
    }
    It 'should return "ldapConfiguration"' {
        Get-ImportClientConfigurationType -Configuration $ldapXml | Should -BeExactly 'ldapConfiguration'
    }
    It 'should return "jdbcConfiguration"' {
        Get-ImportClientConfigurationType -Configuration $jdbcXml | Should -BeExactly 'jdbcConfiguration'
    }
    It 'should return "fileConfiguration"' {
        Get-ImportClientConfigurationType -Configuration $fileXml | Should -BeExactly 'fileConfiguration'
    }
    It 'should throw if configuration is not known' {
        {Get-ImportClientConfigurationType -Configuration $unknownXml} | Should -Throw
    }
}