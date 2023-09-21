function Get-EasitGOItem {
    <#
    .SYNOPSIS
        Get data from Easit GO.
    .DESCRIPTION
        Sends a GET request to the Easit GO WebAPI and returns the result of the request.
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
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
        }
        $easitObjects = Get-EasitGOItem @getEasitGOItemParams
        foreach ($easitObject in $easitObjects.items.item.GetEnumerator()) {
            Write-Host "Got object with database id $($easitGOObject.id)"
            Write-Host "The object has the following properties and values"
            foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
            }
        }
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            GetAllPages = $true
        }
        $pages = Get-EasitGOItem @getEasitGOItemParams
        foreach ($page in $pages) {
            foreach ($easitObject in $page.items.item.GetEnumerator()) {
                Write-Host "Got object with database id $($easitGOObject.id)"
                Write-Host "The object has the following properties and values"
                foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                    Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
                }
            }
        }
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            GetAllPages = $true
            ReturnAsSeparateObjects = $true
        }
        $easitObjects = Get-EasitGOItem @getEasitGOItemParams
        foreach ($easitObject in $easitObjects.GetEnumerator()) {
            Write-Host "Got object with database id $($easitGOObject.id)"
            Write-Host "The object has the following properties and values"
            foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
            }
        }
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
    [CmdletBinding(DefaultParameterSetName = 'OneObject')]
    param (
        [Parameter(Mandatory,ParameterSetName='OneObject')]
        [Parameter(Mandatory,ParameterSetName='SeparateObjects')]
        [string]$Url,
        [Parameter(Mandatory,ParameterSetName='OneObject')]
        [Parameter(Mandatory,ParameterSetName='SeparateObjects')]
        [Alias('api','key')]
        [string]$Apikey,
        [Parameter(Mandatory,ParameterSetName='OneObject')]
        [Parameter(Mandatory,ParameterSetName='SeparateObjects')]
        [Alias("view")]
        [string]$ImportViewIdentifier,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [SortColumn]$SortColumn,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [Alias('viewPageNumber')]
        [int]$Page,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [int]$PageSize,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [ColumnFilter[]]$ColumnFilter,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [string]$IdFilter,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [string]$FreeTextFilter,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [Alias('irmParams')]
        [System.Collections.Hashtable]$InvokeRestMethodParameters,
        [Parameter(ParameterSetName='OneObject')]
        [Parameter(ParameterSetName='SeparateObjects')]
        [Switch]$GetAllPages,
        [Parameter(ParameterSetName='SeparateObjects')]
        [Switch]$ReturnAsSeparateObjects,
        [Parameter(ParameterSetName='SeparateObjects')]
        [int]$ThrottleLimit = 5,
        [Parameter(ParameterSetName='SeparateObjects')]
        [Switch]$FlatReturnObject,
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
            $cgirParams = @{
                Response = $response
                FlatReturnObject = $FlatReturnObject
                ThrottleLimit = $ThrottleLimit
            }
            try {
                Convert-GetItemsResponse @cgirParams
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
                    $cgirParams = @{
                        Response = $response
                        FlatReturnObject = $FlatReturnObject
                        ThrottleLimit = $ThrottleLimit
                    }
                    try {
                        Convert-GetItemsResponse @cgirParams
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