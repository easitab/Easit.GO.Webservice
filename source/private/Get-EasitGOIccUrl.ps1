function Get-EasitGOIccUrl {
    <#
    .SYNOPSIS
        Combines an URL with a query string into one string.
    .DESCRIPTION
        The **Get-EasitGOIccUrl** uses the [System.UriBuilder](https://learn.microsoft.com/en-us/dotnet/api/system.uribuilder) class to construct an URL that can be sent to Easit GO for retrieving ImportClient configuration.
    .EXAMPLE
        $queryParams = [ordered]@{
            apikey = $Apikey
            identifier = $Identifier
        }
        $queryString = New-UriQueryString -QueryParams $queryParams
        Get-EasitGOIccUrl -URL $iccURL -Query $queryString
    .PARAMETER Url
        URL to combine with a query string.
    .PARAMETER Query
        Query string to to combine with an URL.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType([System.String])]
    [CmdletBinding()]
        param (
            [Parameter(Mandatory, Position=0)]
            [String]$Url,
            [Parameter()]
            [String]$Query
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $requestUrl = [System.UriBuilder]::new($Url)
        } catch {
            throw $_
        }
        if ($null -eq $requestUrl) {
            throw "System.UriBuilder failed to parse Url ($Url)"
        }
        if ($null -eq $Query) {} else {
            $requestUrl.Query = $Query
        }
        return $requestUrl.Uri.OriginalString
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}