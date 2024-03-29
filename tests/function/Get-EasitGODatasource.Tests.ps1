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
    function Resolve-EasitGOUrl {
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
    function New-GetEasitGODatasourceRequestBody {
        param (
            [Parameter()]
            [String]$ModuleId,
            [Parameter()]
            [System.Collections.Hashtable]$ConvertToJsonParameters
        )
        [System.Collections.Hashtable]@{
            moduleId = $ModuleId
        } | ConvertTo-Json
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
    function Convert-EasitGODatasourceResponse {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$Response,
            [Parameter()]
            [int]$ThrottleLimit = 5
        )
            $Response.datasource.GetEnumerator() | ForEach-Object -Parallel {
                try {
                    return [PSCustomObject]$_
                } catch {
                    throw $_
                }
            } -ThrottleLimit $ThrottleLimit
    }
    $getDatasourceFromEasitGO = @{
        Url = 'https://url.to.EasitGO'
        Apikey = 'myApiKey'
        ModuleId = 1001
    }
}
Describe "Get-EasitGODatasource" -Tag 'function','public' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type 'String'
    }
    It 'should have a parameter named Apikey that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Apikey -Mandatory -Type 'String'
    }
    It 'should have a parameter named ModuleId that is mandatory and accepts an integer.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ModuleId -Mandatory -Type Int
    }
    It 'should have a parameter named ParentRawValue that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ParentRawValue -Type 'String'
    }
    It 'should have a parameter named InvokeRestMethodParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InvokeRestMethodParameters -Type 'hashtable'
    }
    It 'should have a parameter named ReturnAsSeparateObjects that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ReturnAsSeparateObjects -Type 'switch'
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
    It 'all parameters should have a description' {
        $commonParameters = [System.Management.Automation.PSCmdlet]::CommonParameters
        $optionalCommonParameters = [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
        foreach ($param in (Get-Help -Name "$($envSettings.CommandName)" -Full).parameters.parameter) {
            if ($commonParameters -notcontains $param.name -and $optionalCommonParameters -notcontains $param.name) {
                ($param.description.Text).Length | Should -BeGreaterThan 0
            }
        }
    }
    It 'should not throw' {
        {Get-EasitGODatasource @getDatasourceFromEasitGO} | Should -Not -Throw
    }
    It 'should return a PSCustomObject' {
        $output = Get-EasitGODatasource @getDatasourceFromEasitGO
        $output | Should -BeOfType PSCustomObject
    }
    It 'should return 1 objects when ReturnAsSeparateObjects is false' {
        $output = Get-EasitGODatasource @getDatasourceFromEasitGO
        $output.Count | Should -BeExactly 1
    }
    It 'should return a array of System.Object when ReturnAsSeparateObjects is true' {
        $output = @()
        $output += Get-EasitGODatasource @getDatasourceFromEasitGO -ReturnAsSeparateObjects
        $output.GetType() | Should -BeExactly 'System.Object[]'
    }
    It 'should return 4 objects when ReturnAsSeparateObjects is true' {
        $output = @()
        $output += Get-EasitGODatasource @getDatasourceFromEasitGO -ReturnAsSeparateObjects
        $output.Count | Should -BeExactly 4
    }
}