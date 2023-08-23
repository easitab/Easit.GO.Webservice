function Get-EasitGOItem {
    <#
    .SYNOPSIS
        Get data from Easit GO.
    .DESCRIPTION
        Sends an get request to the Easit GO WebAPI and returns the result of the request.
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            Page = 2
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            IdFilter = '4659:3'
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
            PageSize = 500
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
        $columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
        $sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
            SortColumn = $sortColumn
        }
        Get-EasitGOItem @getEasitGOItemParams
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER ImportViewIdentifier
        View to get data from.
    .PARAMETER SortColumn
        Used to sort data by a field / property and order (ascending / descending).
    .PARAMETER Page
        Specifies what page in the view to get data from.
    .PARAMETER PageSize
        Specifies number of items each page returns.
    .PARAMETER ColumnFilter
        Used to filter data.
    .PARAMETER IdFilter
        Database id for item to get.
    .PARAMETER FreeTextFilter
        Used to search a view with a text string.
    .PARAMETER InvokeRestMethodParameters
        Set of additional parameters for Invoke-RestMethod. Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER ReturnAsSeparateObjects
        Specifies if *Get-EasitGOItem* should return each item in the view as its own PSCustomObject.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json. Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.
    .PARAMETER GetAllPages
        Specifies if the function should try to get all pages from a view.
    #>
    [OutputType('PSCustomObject')]
    [Alias('Get-GOItems')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [Alias('api','key')]
        [string]$Apikey,
        [Parameter(Mandatory)]
        [Alias("view")]
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
        [Alias('irmParams')]
        [System.Collections.Hashtable]$InvokeRestMethodParameters,
        [Parameter()]
        [Switch]$GetAllPages,
        [Parameter()]
        [Switch]$ReturnAsSeparateObjects,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Get
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOURL -URL $URL -Endpoint 'items'
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Credential = Get-EasitGOCredentialObject -Apikey $Apikey
        } catch {
            throw $_
        }
        try {
            $newGetEasitGOItemsRequestBodyParams = @{
                ImportViewIdentifier = $ImportViewIdentifier
                Page = $Page
                PageSize = $PageSize
                SortColumn = $SortColumn
                ColumnFilter = $ColumnFilter
                FreeTextFilter = $FreeTextFilter
                IdFilter = $IdFilter
                ConvertToJsonParameters = $ConvertToJsonParameters
            }
        } catch {
            throw $_
        }
        if ($GetAllPages) {
            try {
                $newGetEasitGOItemsRequestBodyParams.Page = 1
                $lastPage = 1000
            } catch {
                throw $_
            }
        } else {
            try {
                $lastPage = $Page
            } catch {
                throw $_
            }
        }
        try {
            $baseRMParams.Body = New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        } catch {
            throw $_
        }
        if ($null -eq $InvokeRestMethodParameters) {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
            } catch {
                throw $_
            }
        } else {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
        if ($ReturnAsSeparateObjects) {
            try {
                Convert-GetItemsResponse -Response $response
            } catch {
                throw $_
            }
        } else {
            Write-Output $response
        }
        $currentPage = $response.requestedPage
        $lastPage = $response.totalNumberOfPages
        if ($GetAllPages) {
            $currentPage++
            do {
                $response = $null
                try {
                    $newGetEasitGOItemsRequestBodyParams.Page = $currentPage
                } catch {
                    throw $_
                }
                try {
                    $baseRMParams.Body = New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
                } catch {
                    throw $_
                }
                if ($null -eq $InvokeRestMethodParameters) {
                    try {
                        $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
                    } catch {
                        throw $_
                    }
                } else {
                    try {
                        $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
                    } catch {
                        throw $_
                    }
                }
                if ($ReturnAsSeparateObjects) {
                    try {
                        Convert-GetItemsResponse -Response $response
                    } catch {
                        throw $_
                    }
                } else {
                    Write-Output $response
                }
                $currentPage++
            } while ($currentPage -le $lastPage)
        }
    }
    end {
        [System.GC]::Collect()
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}