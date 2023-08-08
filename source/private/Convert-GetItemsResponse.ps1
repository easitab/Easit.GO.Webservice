function Convert-GetItemsResponse {
    <#
    .SYNOPSIS
        Converts items in a GetItems JSON response to PSCustomObjects.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each item in a GetItems JSON response to a PSCustomObject.
    .EXAMPLE
        $response = Invoke-EasitWebRequest -url $url -api $api -body $body
        Convert-GetItemsResponse -Response $reponse
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
        if ($Response.totalNumberOfItems -lt 1) {
            Write-Warning "View did not return any Easit GO objects"
            return
        }
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            try {
                New-GetItemsReturnObject -Response $using:Response -Item $_
            } catch {
                throw $_
            }
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}