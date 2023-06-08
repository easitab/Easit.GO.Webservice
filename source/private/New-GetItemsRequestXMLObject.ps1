function New-GetItemsRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base GetItemsRequest XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        **New-GetItemsRequestXMLObject** checks if the variable *xmlRequestObject* is null and if so calls **New-RequestXMLObject**.
        **New-GetItemsRequestXMLObject** then creates a new *GetItemsRequest* element and saves it in a script scoped variable named *GetItemsRequest*,
        it then adds at least the following elements to that GetItemsRequest element:

        - ItemViewIdentifier
        - Page
    .EXAMPLE
        $params = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @params
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName '[name]' -Comparator '[comparator]' -ColumnValue '[value]'
        $params = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            ColumnFilters = $columnFilters
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @params
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName '[name]' -RawValue '[rawValue]' -Comparator '[comparator]'
        $sortColumn = New-SortColumn -Name '[columnName]' -Order '[sortOrder]'
        $sortColumn = New-SortColumn -Name 'Uppdaterad' -Order 'Descending'
        $params = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            SortColumn = $sortColumn
            ColumnFilters = $columnFilters
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @params
    .EXAMPLE
        $params = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            IdFilter = "46:5"
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @params
    .EXAMPLE
        $params = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            ItemViewIdentifier = 'view'
            FreeTextFilter = "my free text filter"
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-GetItemsRequestXMLObject @params
    .PARAMETER ItemViewIdentifier
        Value set as ItemViewIdentifier for request.
    .PARAMETER Page
        If specifiied, a element named Page will be appended to the GetItemsRequest element and its input set as the element innertext.
    .PARAMETER PageSize
        If specifiied, a element named PageSize will be appended to the GetItemsRequest element and its input set as the element innertext.
    .PARAMETER SortColumn
        If specifiied, a element named SortColumn will be appended to the GetItemsRequest element and its input used to create a SortColumn element.
    .PARAMETER ColumnFilters
        If specifiied, one or more elements named ColumnFilter will be appended to the GetItemsRequest element and its input used to create one or more ColumnFilter elements.
    .PARAMETER FreeTextFilter
        If specifiied, a element named FreeTextFilter will be appended to the GetItemsRequest element and its input set as the element innertext.
    .PARAMETER IdFilter
        If specifiied, a element named IdFilter will be appended to the GetItemsRequest element and its input set as the element innertext.
    .PARAMETER RequestPrefix
        Prefix used for elements appended to the Body element.
    .PARAMETER EnvelopePrefix
        Prefix used for elements appended to the Envelope element.
    .PARAMETER NamespaceURI
        URI used for the envelope namespace.
    .PARAMETER NamespaceSchema
        URI used for the body elements namespace.
    .OUTPUTS
        This function does not output anything.
        This function sets a script variable named *GetItemsRequest*.
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
        if ([string]::IsNullOrWhiteSpace($EnvelopePrefix)) {
            throw "EnvelopePrefix is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($RequestPrefix)) {
            throw "RequestPrefix is null or empty"
        }
        if ($null -eq $xmlRequestObject) {
            $newRequestXMLObjectParams = @{
                NamespaceURI = $NamespaceURI
                NamespaceSchema = $NamespaceSchema
                EnvelopePrefix = $EnvelopePrefix
                RequestPrefix = $RequestPrefix
                ErrorAction = 'Stop'
            }
            try {
                New-RequestXMLObject @newRequestXMLObjectParams
            } catch {
                throw $_
            }
        }
        try {
            $newElementParams = @{
                Prefix = $RequestPrefix
                NamespaceSchema = $NamespaceSchema
                ErrorAction = 'Stop'
            }
        } catch {
            Write-Warning "Failed to create newElementParams"
            throw $_
        }
        Write-Debug "Creating xml element for GetItemsRequest"
        try {
            New-Variable -Name 'GetItemsRequest' -Scope Script -Value (New-XMLElementObject -Name 'GetItemsRequest' @newElementParams)
            $envelopeBody.AppendChild((Get-Variable -Name 'GetItemsRequest' -ValueOnly)) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for GetItemsRequest"
            throw $_
        }
        try {
            $getItemsRequestElements = New-Object System.Collections.Generic.List[System.Xml.XmlElement]
        } catch {
            Write-Warning "Failed to create new list for XmlElements"
            throw $_
        }
        Write-Debug "Creating xml element for ItemViewIdentifier"
        try {
            $getItemsRequestElements.Add((New-XMLElementObject -Name 'ItemViewIdentifier' -Value $ItemViewIdentifier @newElementParams))
        } catch {
            Write-Warning "Failed to create xml element for Page"
            throw $_
        }
        if ($Page -eq 0) {
            $Page = 1
        }
        Write-Debug "Creating xml element for Page"
        try {
            $getItemsRequestElements.Add((New-XMLElementObject -Name 'Page' -Value $Page @newElementParams))
        } catch {
            Write-Warning "Failed to create xml element for Page"
            throw $_
        }
        if ($PageSize -gt 0) {
            Write-Debug "Creating xml element for PageSize"
            try {
                $getItemsRequestElements.Add((New-XMLElementObject -Name 'PageSize' -Value $PageSize @newElementParams))
            } catch {
                Write-Warning "Failed to create xml element for Page"
                throw $_
            }
        }
        if ($SortColumn) {
            Write-Debug "Creating xml element for SortColumn"
            try {
                $getItemsRequestElements.Add(($SortColumn.ConvertToXMLElement($newElementParams)))
            } catch {
                Write-Warning "Failed to create xml element for SortColumn"
                throw $_
            }
        }
        if (!([string]::IsNullOrWhiteSpace($FreeTextFilter))) {
            Write-Debug "Creating xml element for FreeTextFilter"
            try {
                $getItemsRequestElements.Add((New-XMLElementObject -Name 'FreeTextFilter' -Value $IdFilter @newElementParams))
            } catch {
                Write-Warning "Failed to create xml element for FreeTextFilter"
                throw $_
            }
        }
        foreach ($columnFilter in $ColumnFilters) {
            Write-Debug "Creating xml element for columnFilter ($($columnFilter.ColumnName))"
            try {
                $getItemsRequestElements.Add(($columnFilter.ConvertToXMLElement($newElementParams)))
            } catch {
                Write-Warning "Failed to create xml element for ColumnFilter"
                throw $_
            }
        }
        if (!([string]::IsNullOrWhiteSpace($IdFilter))) {
            Write-Debug "Creating xml element for IdFilter"
            try {
                $getItemsRequestElements.Add((New-XMLElementObject -Name 'IdFilter' -Value $IdFilter @newElementParams))
            } catch {
                Write-Warning "Failed to create xml element for IdFilter"
                throw $_
            }
        }
        foreach ($getItemsRequestElement in $getItemsRequestElements) {
            try {
                $GetItemsRequest.AppendChild($getItemsRequestElement) | Out-Null
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}