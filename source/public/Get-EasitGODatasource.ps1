function Get-EasitGODatasource {
    <#
    .SYNOPSIS
        Get datasources from Easit GO.
    .DESCRIPTION
        With **Get-EasitGODatasource** you can get datasources for a specific module from Easit GO. If no *ParentRawValue* is provided the function returns the modules root datasources.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all datasources in the root in the module with id 1001.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
            ParentRawValue = '5:1'
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
            ParentRawValue = '5:1'
            ReturnAsSeparateObjects = $true
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001 and we want them returned as separate objects.
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER ModuleId
        Specifies what module to get datasources from.
    .PARAMETER ParentRawValue
        Specifies what datasource to get child datasources from. If not specified, root level datasources will be returned.
    .PARAMETER InvokeRestMethodParameters
        Set of additional parameters for Invoke-RestMethod. Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER ReturnAsSeparateObjects
        Specifies if *Get-EasitGOItem* should return each item in the view as its own PSCustomObject.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json. Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding(HelpUri = 'https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/geteasitgodatasource/')]
    param (
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [string]$Apikey,
        [Parameter(Mandatory)]
        [int]$ModuleId,
        [Parameter()]
        [string]$ParentRawValue,
        [Parameter()]
        [Alias('irmParams')]
        [hashtable]$InvokeRestMethodParameters,
        [Parameter()]
        [Switch]$ReturnAsSeparateObjects,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Get
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOUrl -URL $URL -Endpoint 'datasources'
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Credential = Get-EasitGOCredentialObject -Apikey $Apikey
        } catch {
            throw $_
        }
        try {
            $newGetEasitGODatasourceRequestBodyParams = @{
                moduleId = $ModuleId
                ConvertToJsonParameters = $ConvertToJsonParameters
            }
        } catch {
            throw $_
        }
        if ([string]::IsNullOrEmpty($ParentRawValue)) {
            Write-Verbose "No parent raw value provided"
        } else {
            try {
                $newGetEasitGODatasourceRequestBodyParams.Add('parentRawValue',$ParentRawValue)
            } catch {
                throw $_
            }
        }
        try {
            $baseRMParams.Body = New-GetEasitGODatasourceRequestBody @newGetEasitGODatasourceRequestBodyParams
        } catch {
            throw $_
        }
        if ($null -eq $InvokeRestMethodParameters) {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
            } catch {
                throw $_
            }
        } else {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
        if ($ReturnAsSeparateObjects) {
            try {
                Convert-EasitGODatasourceResponse -Response $response
            } catch {
                throw $_
            }
        } else {
            return $response
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}