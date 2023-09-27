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

    function Resolve-EasitGOUrl {
        param (
            [Parameter()]
            [String]$URL,
            [Parameter()]
            [String]$Endpoint
        )
        return 'https://url.to.EasitGO/integration-api/null'
    }
    function New-UriQueryString {
        param (
            [Parameter()]
            [System.Collections.Specialized.OrderedDictionary]$QueryParams
        )
        $queryHash = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        foreach ($param in $QueryParams.GetEnumerator()) {
            try {
                $queryHash.Add("$($param.Name)","$($param.Value)")
            } catch {
                throw $_
            }
        }
        return $queryHash.ToString()
    }
    function Get-EasitGOIccUrl {
        param (
            [Parameter(Mandatory, Position=0)]
            [String]$URL,
            [Parameter()]
            [String]$Query
        )
        $requestUrl = [System.UriBuilder]$URL
        $requestUrl.Query = $Query
        return $requestUrl.Uri.OriginalString
    }
    function Invoke-EasitGOXmlWebRequest {
        param (
            [Parameter()]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters,
            [Parameter()]
            [String]$FileName
        )
        if ($BaseParameters.Uri -match 'identifier=ldap') {
            Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'ldapConfiguration.xml') -Raw
        }
        if ($BaseParameters.Uri -match 'identifier=jdbc') {
            Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'jdbcConfiguration.xml') -Raw
        }
        if ($BaseParameters.Uri -match 'identifier=file') {
            Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'fileConfiguration.xml') -Raw
        }
    }
    function Get-BaseSoapRequestParameter {
        param (
            [Parameter()]
            [Switch]$NoUri,
            [Parameter()]
            [Switch]$ContentType,
            [Parameter()]
            [Switch]$ErrorHandling
        )
        [ordered]@{
            Uri = $null
            ContentType = 'text/xml;charset=utf-8'
            ErrorAction = 'Stop'
        }
    }
    function Get-ImportClientConfigurationType {
        param (
            [Parameter()]
            [System.Xml.XmlDocument]$Configuration
        )
        (Select-Xml -Xml $Configuration -XPath "*").Node.localname
    }
    function New-ImportClientConfigurationInstance {
        param (
            [Parameter(Mandatory)]
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
    function New-EasitGOImportClientConfiguration {
        param (
            [System.Xml.XmlDocument]$Configuration
        )
        $configurationType = Get-ImportClientConfigurationType -Configuration $Configuration
        $configurationInstance = New-ImportClientConfigurationInstance -ConfigurationType $configurationType
        $configurationInstance.SetPropertyValuesFromXml($Configuration)
        $configurationInstance.ToPSCustomObject()
    }
    $getFromEasitParamsLdap = @{
        Url = 'https://go.easit.com'
        Apikey = 'myApikey'
        Identifier = 'ldap'
    }
    $getFromEasitParamsJdbc = @{
        Url = 'https://go.easit.com'
        Apikey = 'myApikey'
        Identifier = 'jdbc'
    }
    $getFromEasitParamsFile = @{
        Url = 'https://go.easit.com'
        Apikey = 'myApikey'
        Identifier = 'file'
    }
}
Describe "Get-EasitGOImportClientConfiguration" -Tag 'function','public' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type [String]
    }
    It 'should have a parameter named Apikey that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Apikey -Mandatory -Type [String]
    }
    It 'should have a parameter named Identifier that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Identifier -Mandatory -Type [String]
    }
    It 'should have a parameter named InvokeWebRequestParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InvokeWebRequestParameters -Type [System.Collections.Hashtable]
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
    It 'should have a HelpUri' {
        ((Get-Command "$($envSettings.CommandName)").HelpUri).Length | Should -BeGreaterThan 0
    }
    It 'should not throw (ldap)' {
        {Get-EasitGOImportClientConfiguration @getFromEasitParamsLdap} | Should -Not -Throw
    }
    It 'should return a PSCustomObject (ldap)' {
        Get-EasitGOImportClientConfiguration @getFromEasitParamsLdap | Should -BeOfType [PSCustomObject]
    }
    It 'returned object should have some predefined values (ldap)' {
        $config = Get-EasitGOImportClientConfiguration @getFromEasitParamsLdap
        $config.itemsPerPosting | Should -BeExactly 10
        $config.identifier | Should -BeExactly 'ldap'
        $config.sleepBetweenPostings | Should -BeExactly 5
    }
    It 'should not throw (jdbc)' {
        {Get-EasitGOImportClientConfiguration @getFromEasitParamsJdbc} | Should -Not -Throw
    }
    It 'should return a PSCustomObject (jdbc)' {
        Get-EasitGOImportClientConfiguration @getFromEasitParamsJdbc | Should -BeOfType [PSCustomObject]
    }
    It 'returned object should have some predefined values (jdbc)' {
        $config = Get-EasitGOImportClientConfiguration @getFromEasitParamsJdbc
        $config.itemsPerPosting | Should -BeExactly 100
        $config.identifier | Should -BeExactly 'csv_contacts'
        $config.sleepBetweenPostings | Should -BeExactly 0
    }
    It 'should not throw (file)' {
        {Get-EasitGOImportClientConfiguration @getFromEasitParamsFile} | Should -Not -Throw
    }
    It 'should return a PSCustomObject (file)' {
        Get-EasitGOImportClientConfiguration @getFromEasitParamsFile | Should -BeOfType [PSCustomObject]
    }
    It 'returned object should have some predefined values (file)' {
        $config = Get-EasitGOImportClientConfiguration @getFromEasitParamsFile
        $config.itemsPerPosting | Should -BeExactly 1
        $config.identifier | Should -BeExactly 'fileConfiguration'
        $config.sleepBetweenPostings | Should -BeExactly 1
    }
}