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
    function Get-BaseRestMethodParameter {
        param (
            [Parameter()]
            [Switch]$Get
        )
        return [System.Collections.Hashtable]@{
            Url = 'https://url.to.EasitGO'
            Method = 'Get'
            ContentType = 'application/json'
            Authentication = 'Basic'
            Credential = $null
        }
    }
    function Resolve-EasitGOURL {
        param (
            [Parameter()]
            [String]$URL,
            [Parameter()]
            [String]$Endpoint
        )
        return 'https://url.to.EasitGO/integration-api/datasources/'
    }
    function Get-EasitGOCredentialObject {
        param (
            [Parameter()]
            [String]$Apikey
        )
        [securestring]$secString = ConvertTo-SecureString $Apikey -AsPlainText -Force
        New-Object System.Management.Automation.PSCredential ($Apikey, $secString)
    }
    function New-GetEasitGOItemsRequestBody {
        param (
            [Parameter()]
            [string]$ImportViewIdentifier,
            [Parameter()]
            [SortColumn]$SortColumn,
            [Parameter()]
            [int]$Page,
            [Parameter()]
            [int]$PageSize,
            [Parameter()]
            [ColumnFilter[]]$ColumnFilter,
            [Parameter()]
            [string]$IdFilter,
            [Parameter()]
            [string]$FreeTextFilter,
            [Parameter()]
            [System.Collections.Hashtable]$ConvertToJsonParameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceRequest.json') -Raw | ConvertFrom-Json
    }
    function Convert-ToEasitGOJson {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$InputObject,
            [Parameter()]
            [System.Collections.Hashtable]$Parameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getRequest_base.json') -Raw | ConvertFrom-Json
    }
    function Invoke-EasitGOWebRequest {
        param (
            [Parameter()]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceResponse.json') -Raw | ConvertFrom-Json
    }
    $getFromEasitParams = @{
        Url = 'https://go.easit.com'
        Apikey = 'myApikey'
        ImportViewIdentifier = 'testview'
    }
}
Describe "Get-EasitGOItem" -Tag 'function','public' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type 'String'
    }
    It 'should have a parameter named Apikey that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Apikey -Mandatory -Type 'String'
    }
    It 'should have a parameter named ImportViewIdentifier that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ImportViewIdentifier -Mandatory -Type 'String'
    }
    It 'should have a parameter named InvokeRestMethodParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InvokeRestMethodParameters -Type 'System.Collections.Hashtable'
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
        {Get-EasitGOItem @getFromEasitParams} | Should -Not -Throw
    }
}