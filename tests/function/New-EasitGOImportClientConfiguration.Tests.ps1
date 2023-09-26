BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    foreach ($class in Get-ChildItem -Path (Join-Path $envSettings.SourceDirectory -ChildPath 'classes') -Recurse -File) {
        . $class.FullName
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
    function Get-ImportClientConfigurationType {
        param (
            [Parameter()]
            [xml]$Configuration
        )
        (Select-Xml -Xml $Configuration -XPath "*").Node.localname
    }
    function New-ImportClientConfigurationInstance {
        param (
            [Parameter()]
            [String]$ConfigurationType
        )
        if ($ConfigurationType -eq 'ldapConfiguration') {
            try {
                [EasitGOImportClientLdapConfiguration]::New()
            } catch {
                throw $_
            }
        } elseif ($ConfigurationType -eq 'jdbcConfiguration') {
            try {
                [EasitGOImportClientJdbcConfiguration]::New()
            } catch {
                throw $_
            }
        } elseif ($ConfigurationType -eq 'fileConfiguration') {
            try {
                [EasitGOImportClientXmlConfiguration]::New()
            } catch {
                throw $_
            }
        } else {
            throw "Unknown configuration type"
        }
    }
}
Describe "New-EasitGOImportClientConfiguration" -Tag 'function','private' {
    It 'should have a parameter named Configuration that accepts a XML document' {
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
    It 'should not throw if configuration type is ldap' {
        {New-EasitGOImportClientConfiguration -Configuration $ldapXml} | Should -Not -Throw
    }
    It 'should not throw if configuration type is jdbc' {
        {New-EasitGOImportClientConfiguration -Configuration $jdbcXml} | Should -Not -Throw
    }
    It 'should not throw if configuration type is file' {
        {New-EasitGOImportClientConfiguration -Configuration $fileXml} | Should -Not -Throw
    }
    It 'should throw if configuration type is unknown' {
        {New-EasitGOImportClientConfiguration -Configuration $unknownXml} | Should -Throw
    }
    It 'should return a PSCustomObject' {
        {New-EasitGOImportClientConfiguration -Configuration $fileXml} | Should -BeOfType [PSCustomObject]
    }
    It 'property check of returned PSCustomObject (ldap)' {
        $config = New-EasitGOImportClientConfiguration -Configuration $ldapXml
        $config.itemsPerPosting | Should -BeExactly 10
        $config.sleepBetweenPostings | Should -BeExactly 5
        $config.disabled | Should -BeExactly 'false'
    }
    It 'property check of returned PSCustomObject (ldap)' {
        $config = New-EasitGOImportClientConfiguration -Configuration $jdbcXml
        $config.itemsPerPosting | Should -BeExactly 100
        $config.sleepBetweenPostings | Should -BeExactly 0
        $config.disabled | Should -BeExactly 'false'
    }
    It 'property check of returned PSCustomObject (ldap)' {
        $config = New-EasitGOImportClientConfiguration -Configuration $fileXml
        $config.itemsPerPosting | Should -BeExactly 1
        $config.sleepBetweenPostings | Should -BeExactly 1
        $config.disabled | Should -BeExactly 'true'
    }
}