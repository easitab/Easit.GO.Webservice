function Convert-GetItemsResponse {
    <#
    .SYNOPSIS
        Converts items in a GetItems JSON response to PSCustomObjects.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each item in a GetItems JSON response to a PSCustomObject.
    .EXAMPLE
        $response = Invoke-EasitGOWebRequest -url $url -api $api -body $body
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
        [Switch]$FlatReturnObject,
        [Parameter()]
        [int]$ThrottleLimit
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($Response.totalNumberOfItems -lt 1) {
            Write-Warning "View did not return any Easit GO objects"
            return
        }
        if ($FlatReturnObject) {
            Write-Debug "Returning flat object"
        } else {
            Write-Debug "Rreturning regular object"
        }
        # If we try to call a module function within ForEach-Object -Parallel
        # without saving it to a variable first and defining module function
        # within ForEach-Object -Parallel with $using:, the function cannot be found.
        # https://github.com/easitab/Easit.GO.Webservice/issues/59
        # https://stackoverflow.com/questions/61273189/how-to-pass-a-custom-function-inside-a-foreach-object-parallel
        $functionDefinition1 = ${function:New-FlatGetItemsReturnObject}.ToString()
        $functionDefinition2 = ${function:New-GetItemsReturnObject}.ToString()
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            $flatReturnObject = $using:FlatReturnObject
            $ngiroParams = @{
                Response = $using:Response
                Item = $_
            }
            if ($flatReturnObject) {
                ${function:New-FlatGetItemsReturnObject} = $using:functionDefinition1
                try {
                    New-FlatGetItemsReturnObject @ngiroParams
                } catch {
                    throw $_
                }
            } else {
                ${function:New-GetItemsReturnObject} = $using:functionDefinition2
                try {
                    New-GetItemsReturnObject @ngiroParams
                } catch {
                    throw $_
                }
            }
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}