function New-SortColumn {
    <#
    .SYNOPSIS
        Creates a new instance of the SortColumn class.
    .DESCRIPTION
        **New-SortColumn** acts as a wrapper function for the SortColumn class included in the module Easit.GO.Webservice.
        With the provided input it returns an instance of the SortColumn class.
    .EXAMPLE
        try {
            $sortColumn += New-SortColumn -Name 'Created' -Order 'Descending'
        } catch {
            throw $_
        }
    .PARAMETER Name
        Name of field in Easit GO to sort on.
    .PARAMETER Order
        Order to sort by.
    .OUTPUTS
        [SortColumn](https://docs.easitgo.com/techspace/psmodules/)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [ValidateSet('Ascending','Descending')]
        [String]$Order
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            [SortColumn]::New($Name,$Order)
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}