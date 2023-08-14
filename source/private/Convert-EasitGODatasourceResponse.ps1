function Convert-EasitGODatasourceResponse {
    <#
    .SYNOPSIS
        Converts datasources in a GetDatasources JSON response to PSCustomObjects.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each datasource in a GetDatasources JSON response to a PSCustomObject.
    .EXAMPLE
        $response = Invoke-EasitGOWebRequest @baseParams
        Convert-EasitGODatasourceResponse -Response $reponse
    .PARAMETER Response
        Response object to convert
    .PARAMETER ThrottleLimit
        Specifies the number of script blocks that run in parallel. Input objects are blocked until the running script block count falls below the ThrottleLimit.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter()]
        [int]$ThrottleLimit = 5
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($Response.datasource.Count -eq 0) {
            Write-Warning "Response does not contain any datasources"
        }
        $Response.datasource.GetEnumerator() | ForEach-Object -Parallel {
            try {
                return [PSCustomObject]$_
            } catch {
                throw $_
            }
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}