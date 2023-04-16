function New-GetItemsRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base ImportItemRequest XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a base ImportItemRequest XML object, based on the XML returned by *New-RequestXMLObject*.
        *New-ImportItemRequestXMLObject* checks if the variable *xmlRequestObject* is null and if so calls *New-RequestXMLObject*
        to create a new request base XML object as value for the variable *xmlRequestObject* in the script scope. It then adds the following elements:

        - ImportItemsRequest
        - ImportHandlerIdentifier
    .EXAMPLE
        New-ImportItemRequestXMLObject -ImportHandlerIdentifier $ImportHandlerIdentifier -NamespaceURI $NamespaceURI -NamespaceSchema $NamespaceSchema
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName '[name]' -Comparator '[comparator]' -ColumnValue '[value]'
        $newGetItemsRequestXMLObjectParams = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            ColumnFilters = $columnFilters
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @newGetItemsRequestXMLObjectParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName '[name]' -RawValue '[rawValue]' -Comparator '[comparator]'
        $sortColumn = New-SortColumn -Name '[columnName]' -Order '[sortOrder]'
        $sortColumn = New-SortColumn -Name 'Uppdaterad' -Order 'Descending'
        $newGetItemsRequestXMLObjectParams = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            SortColumn = $sortColumn
            ColumnFilters = $columnFilters
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @newGetItemsRequestXMLObjectParams
    .EXAMPLE
        $newGetItemsRequestXMLObjectParams = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            IdFilter = "46:5"
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @newGetItemsRequestXMLObjectParams
    .EXAMPLE
        $newGetItemsRequestXMLObjectParams = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            FreeTextFilter = "my free text filter"
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @newGetItemsRequestXMLObjectParams
    .PARAMETER ImportHandlerIdentifier
        Value set as ImportHandlerIdentifier for request.
    .PARAMETER NamespaceURI
        URI used for the envelope namespace (xmlns:soapenv).
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
    .OUTPUTS
        This function does not output anything.
        This function sets a script variable named *schImportItemsRequest* ($script:schImportItemsRequest).
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceURI,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter(Mandatory)]
        [String]$ItemViewIdentifier,
        [Parameter()]
        [Int]$Page,
        [Parameter()]
        [Int]$PageSize,
        [Parameter()]
        [SortColumn]$SortColumn,
        [Parameter()]
        [ColumnFilter[]]$ColumnFilters,
        [Parameter()]
        [String]$FreeTextFilter,
        [Parameter()]
        [String]$IdFilter,
        [Parameter(Mandatory)]
        [String]$EnvelopePrefix,
        [Parameter(Mandatory)]
        [String]$RequestPrefix
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ([string]::IsNullOrWhiteSpace($NamespaceURI)) {
            throw "NamespaceURI is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($NamespaceSchema)) {
            throw "NamespaceSchema is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($ItemViewIdentifier)) {
            throw "ItemViewIdentifier is null or empty"
        }
        if ($null -eq $xmlRequestObject) {
            $newRequestXMLObjectParams = @{
                NamespaceURI = $NamespaceURI
                NamespaceSchema = $NamespaceSchema
                EnvelopePrefix = $EnvelopePrefix
                RequestPrefix = $RequestPrefix
            }
            try {
                New-RequestXMLObject @newRequestXMLObjectParams
            } catch {
                throw $_
            }
        }
        $newElementParams = @{
            Prefix = $RequestPrefix
            NamespaceSchema = $NamespaceSchema
            ErrorAction = 'Stop'
        }
        try {
            Write-Debug "Creating xml element for GetItemsRequest"
            New-Variable -Name 'requestGetItemsRequestElement' -Scope Script -Value (New-XMLElementObject -Name 'GetItemsRequest' @newElementParams)
            $requestBodyElement.AppendChild((Get-Variable -Name 'requestGetItemsRequestElement' -ValueOnly)) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for GetItemsRequest"
            throw $_
        }
        $getItemsRequestElements = New-Object System.Collections.Generic.List[System.Xml.XmlElement]
        Write-Debug "Creating xml elements for GetItemsRequest"
        try {
            Write-Debug "Creating xml element for ItemViewIdentifier"
            $requestItemViewIdentifierElement = New-XMLElementObject -Name 'ItemViewIdentifier' -Value $ItemViewIdentifier @newElementParams
            $getItemsRequestElements.Add($requestItemViewIdentifierElement)
        } catch {
            Write-Warning "Failed to create xml element for Page"
            throw $_
        }
        if ($Page -eq 0) {
            $Page = 1
        }
        try {
            $requestPageElement = New-XMLElementObject -Name 'Page' -Value $Page @newElementParams
            $getItemsRequestElements.Add($requestPageElement)
        } catch {
            Write-Warning "Failed to create xml element for Page"
            throw $_
        }
        if ($PageSize -gt 0) {
            try {
                Write-Debug "Creating xml element for PageSize"
                $requestPageSizeElement = New-XMLElementObject -Name 'PageSize' -Value $PageSize @newElementParams
                $getItemsRequestElements.Add($requestPageSizeElement)
            } catch {
                Write-Warning "Failed to create xml element for Page"
                throw $_
            }
        }
        if ($SortColumn.Name) {
            try {
                Write-Debug "Creating xml element for SortColumn"
                $sortColumnElementParams = @{
                    Name = 'SortColumn'
                    Value = $SortColumn.Name
                    Attributes = @{
                        order = $SortColumn.Order
                    }
                }
                $requestSortColumnElement = New-XMLElementObject @sortColumnElementParams @newElementParams
                $getItemsRequestElements.Add($requestSortColumnElement)
            } catch {
                Write-Warning "Failed to create xml element for SortColumn"
                throw $_
            }
        }
        if (!([string]::IsNullOrWhiteSpace($FreeTextFilter))) {
            try {
                Write-Debug "Creating xml element for FreeTextFilter"
                $requestFreeTextFilterElement = New-XMLElementObject -Name 'FreeTextFilter' -Value $IdFilter @newElementParams
                $getItemsRequestElements.Add($requestFreeTextFilterElement)
            } catch {
                Write-Warning "Failed to create xml element for FreeTextFilter"
                throw $_
            }
        }
        foreach ($columnFilter in $ColumnFilters) {
            $columnFilterElementParams = @{
                Name = 'ColumnFilter'
                Attributes = [ordered]@{
                    columnName = $columnFilter.ColumnName
                    comparator = $columnFilter.Comparator
                }
            }
            if ($columnFilter.RawValue) {
                $columnFilterElementParams.Attributes.Add('rawValue',"$($columnFilter.RawValue)")
            }
            if ($columnFilter.ColumnValue) {
                $columnFilterElementParams.Add('Value',"$($columnFilter.ColumnValue)")
            }
            try {
                $script:requestColumnFilterElement = New-XMLElementObject @columnFilterElementParams @newElementParams
                $getItemsRequestElements.Add($requestColumnFilterElement)
            } catch {
                Write-Warning "Failed to create xml element for IdFilter"
                throw $_
            }
        }
        if (!([string]::IsNullOrWhiteSpace($IdFilter))) {
            try {
                Write-Debug "Creating xml element for IdFilter"
                $requestIdFilterElement = New-XMLElementObject -Name 'IdFilter' -Value $IdFilter @newElementParams
                $getItemsRequestElements.Add($requestIdFilterElement)
            } catch {
                Write-Warning "Failed to create xml element for IdFilter"
                throw $_
            }
        }
        foreach ($getItemsRequestElement in $getItemsRequestElements) {
            try {
                $requestGetItemsRequestElement.AppendChild($getItemsRequestElement) | Out-Null
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}