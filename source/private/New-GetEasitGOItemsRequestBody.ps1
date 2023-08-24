function New-GetEasitGOItemsRequestBody {
    <#
    .SYNOPSIS
        Creates a JSON-formatted string.
    .DESCRIPTION
        **New-GetEasitGOItemsRequestBody** creates a JSON-formatted string from the provided input to use as body for a request sent to Easit GO WebAPI.
    .EXAMPLE
        $newGetEasitGOItemsRequestBodyParams = @{
            ImportViewIdentifier = 'example'
            Page = 2
            PageSize = 50
        }
        New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        {
            "pageSize": 50,
            "page": 2,
            "itemViewIdentifier": "example"
        }
    .EXAMPLE
        $newGetEasitGOItemsRequestBodyParams = @{
            ImportViewIdentifier = 'example'
            Page = 3
            PageSize = 100
            ColumnFilter = $columnFilters
        }
        New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        {
            "pageSize": 100,
            "ColumnFilter": [
                {
                    "comparator": "LIKE",
                    "content": "b",
                    "columnName": "Beskrivning"
                },
                {
                    "comparator": "IN",
                    "rawValue": "81:1",
                    "columnName": "Status"
                }
            ],
            "page": 3,
            "itemViewIdentifier": "example"
        }
    .PARAMETER ImportViewIdentifier
        View to get objects from.
    .PARAMETER SortColumn
        Field / Column and order (Ascending / Descending) to sort objects by.
    .PARAMETER Page
        Used to get objects from a specific page in view.
    .PARAMETER PageSize
        How many objects each page in view should return.
    .PARAMETER ColumnFilter
        Field / Column to filter objects by.
    .PARAMETER IdFilter
        Database id for item to get.
    .PARAMETER FreeTextFilter
        Filter view with a search string.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json.
    .OUTPUTS
        [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('itemViewIdentifier')]
        [string]$ImportViewIdentifier,
        [Parameter()]
        [SortColumn]$SortColumn,
        [Parameter()]
        [int]$Page,
        [Parameter()]
        [int]$PageSize,
        [Parameter()]
        [ColumnFilter[]]$ColumnFilter,
        [Parameter()]
        [string]$IdFilter,
        [Parameter()]
        [string]$FreeTextFilter,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $bodyObject = @{}
        if ($ImportViewIdentifier) {
            try {
                $bodyObject.Add('itemViewIdentifier',$ImportViewIdentifier)
            } catch {
                throw $_
            }
        }
        if ($SortColumn) {
            try {
                $bodyObject.Add('sortColumn',($SortColumn.ToPSCustomObject()))
            } catch {
                throw $_
            }
        }
        if ($Page -gt 0) {
            try {
                $bodyObject.Add('page',$Page)
            } catch {
                throw $_
            }
        }
        if ($PageSize -gt 0) {
            try {
                $bodyObject.Add('pageSize',$PageSize)
            } catch {
                throw $_
            }
        }
        if ($ColumnFilter.Count -gt 0) {
            try {
                $ColumnFilterArray = [System.Collections.Generic.List[Object]]::new()
            } catch {
                throw $_
            }
            foreach ($cf in $ColumnFilter) {
                try {
                    $ColumnFilterArray.Add(($cf.ToPSCustomObject()))
                } catch {
                    throw $_
                }
            }
            try {
                $bodyObject.Add('columnFilter',$ColumnFilterArray)
            } catch {
                throw $_
            }
        }
        if ($IdFilter) {
            try {
                $bodyObject.Add('idFilter',$IdFilter)
            } catch {
                throw $_
            }
        }
        if ($FreeTextFilter) {
            try {
                $bodyObject.Add('freeTextFilter',$FreeTextFilter)
            } catch {
                throw $_
            }
        }
        if ($null -eq $ConvertToJsonParameters) {
            $ConvertToJsonParameters = @{
                Depth = 4
                EscapeHandling = 'EscapeNonAscii'
                WarningAction = 'SilentlyContinue'
            }
        }
        try {
            Convert-ToEasitGOJson -InputObject $bodyObject -Parameters $ConvertToJsonParameters
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}