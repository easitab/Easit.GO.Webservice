function New-GetItemsReturnObject {
    <#
    .SYNOPSIS
        Creates an base PSCustomObject returned by *Convert-GetItemsResponse*.
    .DESCRIPTION
        **New-GetItemsReturnObject** add a property named *viewDetails* with details such as RequestedPage, TotalNumberOfPages and TotalNumberOfItems to an item from a reponse object and returns it.
    .EXAMPLE
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            try {
                New-GetItemsReturnObject -Response $using:Response -Item $_
            } catch {
                throw $_
            }
        }
    .PARAMETER Response
        Response to be used as basis for a new object.
    .PARAMETER Item
        Item in response to be converted / updated.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter(Mandatory)]
        [PSCustomObject]$Item
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $viewDetails = [PSCustomObject]@{
                RequestedPage = $Response.RequestedPage
                Page = $Response.page
                TotalNumberOfPages = $Response.totalNumberOfPages
                TotalNumberOfItems = $Response.totalNumberOfItems
            }
        } catch {
            throw $_
        }
        try {
            $Item | Add-Member -MemberType NoteProperty -Name "ViewDetails" -Value $viewDetails
        } catch {
            throw $_
        }
        return $Item
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}