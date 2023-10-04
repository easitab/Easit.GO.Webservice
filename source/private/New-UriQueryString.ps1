function New-UriQueryString {
    <#
    .SYNOPSIS
        Returns a hashtable as a query string
    .DESCRIPTION
        The **New-UriQueryString** functions takes a ordered dictionary (hashtable) as input and uses *System.Web.HttpUtility* to build a query string from hashtable provided as input.
    .EXAMPLE
        $queryParams = [ordered]@{
            apikey = 'myApiKey'
            identifier = 'identifier'
        }
        New-UriQueryString -QueryParams $queryParams
        apikey=myApiKey&identifier=identifier
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Collections.Specialized.OrderedDictionary]$QueryParams
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
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
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}