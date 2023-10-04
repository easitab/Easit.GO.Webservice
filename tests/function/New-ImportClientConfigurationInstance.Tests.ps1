BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    . (Get-ChildItem -Path (Join-Path -Path $envSettings.SourceDirectory -ChildPath 'classes') -Recurse -File -Include 'EasitGOImportClientConfiguration.Class.ps1').FullName
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
}
Describe "New-ImportClientConfigurationInstance" -Tag 'function','private' {
    It 'should have a parameter named ConfigurationType that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ConfigurationType -Type [System.String]
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
    It 'should not throw with ConfigurationType = ldapConfiguration' {
        {New-ImportClientConfigurationInstance -ConfigurationType 'ldapConfiguration'} | Should -Not -Throw
    }
    It 'should return a object of type EasitGOImportClientLdapConfiguration' {
        $configInstance = New-ImportClientConfigurationInstance -ConfigurationType 'ldapConfiguration'
        $configInstance.GetType() | Should -BeExactly 'EasitGOImportClientLdapConfiguration'
    }
    It 'should not throw with ConfigurationType = jdbcConfiguration' {
        {New-ImportClientConfigurationInstance -ConfigurationType 'jdbcConfiguration'} | Should -Not -Throw
    }
    It 'should return a object of type EasitGOImportClientJdbcConfiguration' {
        $configInstance = New-ImportClientConfigurationInstance -ConfigurationType 'jdbcConfiguration'
        $configInstance.GetType() | Should -BeExactly 'EasitGOImportClientJdbcConfiguration'
    }
    It 'should not throw with ConfigurationType = fileConfiguration' {
        {New-ImportClientConfigurationInstance -ConfigurationType 'fileConfiguration'} | Should -Not -Throw
    }
    It 'should return a object of type EasitGOImportClientXmlConfiguration' {
        $configInstance = New-ImportClientConfigurationInstance -ConfigurationType 'fileConfiguration'
        $configInstance.GetType() | Should -BeExactly 'EasitGOImportClientXmlConfiguration'
    }
    It 'should throw with unknown configuration type' {
        {New-ImportClientConfigurationInstance -ConfigurationType 'unknown'} | Should -Throw
    }
}