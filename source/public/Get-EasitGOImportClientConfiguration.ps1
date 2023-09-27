function Get-EasitGOImportClientConfiguration {
    <#
    .SYNOPSIS
        Get a ImportClient configuration from Easit GO.
    .DESCRIPTION
        With **Get-EasitGOImportClientConfiguration** you can get a configuration used by ImportClient.jar for retrieving object from external sources such as Active Directory or CSV-files.
    .EXAMPLE
        $getIccConfigurationFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            Identifier = 'myImportClientConfiguration'
        }
        $configuration = Get-EasitGOImportClientConfiguration @getIccConfigurationFromEasitGO
        $adUsers = @()
        foreach ($query in $configuration.queries) {
            $adUsers += Get-AdUser -LDAPFilter $query.filter
        }
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER Identifier
        Specifies the name of the confguration to get.
    .PARAMETER InvokeWebRequestParameters
        Set of additional parameters for Invoke-WebRequest. Base parameters sent to Invoke-WebRequest is 'Uri', 'ContentType', 'ErrorAction'.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [Alias('Get-EasitGOIcc')]
    [CmdletBinding(HelpUri='https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/geteasitgoimportclientconfiguration/')]
    param (
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [Alias('api','key')]
        [string]$Apikey,
        [Parameter(Mandatory)]
        [Alias("name")]
        [string]$Identifier,
        [Parameter()]
        [Alias('iwrParams')]
        [System.Collections.Hashtable]$InvokeWebRequestParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseIwrParams = Get-BaseSoapRequestParameter -ContentType -ErrorHandling
        } catch {
            throw $_
        }
        try {
            $resolvedURL = Resolve-EasitGOURL -URL $URL -Endpoint 'null'
            $iccURL = $resolvedURL.Replace('integration-api/null','importclientconfiguration/')
        } catch {
            throw $_
        }
        try {
            $queryParams = [ordered]@{
                apikey = $Apikey
                identifier = $Identifier
            }
            $queryString = New-UriQueryString -QueryParams $queryParams
        } catch {
            throw $_
        }
        try {
            $baseIwrParams.Uri = Get-EasitGOIccUrl -URL $iccURL -Query $queryString
        } catch {
            throw $_
        }
        if ($null -eq $InvokeWebRequestParameters) {
            try {
                $response = Invoke-EasitGOXmlWebRequest -BaseParameters $baseIwrParams
            } catch {
                throw $_
            }
        } else {
            try {
                $response = Invoke-EasitGOXmlWebRequest -BaseParameters $baseIwrParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
        if ($response.error) {
            Write-Warning "Oups, unable to get ImportClient configuration"
            throw $response.error.message
        }
        try {
            New-EasitGOImportClientConfiguration -Configuration $response
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}