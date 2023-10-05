function New-SortColumn {
    <#
    .SYNOPSIS
        Creates a new instance of the SortColumn class.
    .DESCRIPTION
        **New-SortColumn** acts as a wrapper function for the SortColumn class included in the module Easit.GO.Webservice.
        With the provided input it returns an instance of the SortColumn class.
    .EXAMPLE
        try {
            $sortColumn += New-SortColumn -Property 'Created' -Order 'Descending'
        } catch {
            throw $_
        }
    .PARAMETER Property
        Item property in Easit GO to sort on.
    .PARAMETER Order
        Order to sort by.
    .INPUTS
        None - You cannot pipe objects to this function
    .OUTPUTS
        [SortColumn](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/sortcolumn/)
    #>
    [CmdletBinding(HelpUri = 'https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/newsortcolumn/')]
    param (
        [Parameter(Mandatory)]
        [Alias('ColumnName','Name','PropertyName')]
        [String]$Property,
        [Parameter(Mandatory)]
        [ValidateSet('Ascending','Descending')]
        [String]$Order
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            [SortColumn]::New($Property,$Order)
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}