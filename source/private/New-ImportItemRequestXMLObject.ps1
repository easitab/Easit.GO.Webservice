function New-ImportItemRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base ImportItemRequest XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        **New-ImportItemRequestXMLObject** checks if the variable *requestXMLObject* is null and if so calls **New-RequestXMLObject**.
        **New-ImportItemRequestXMLObject** then creates a new *ImportItemsRequest* element and saves it in a script scoped variable named *ImportItemsRequest*,
        it then adds the following elements to that ImportItemsRequest element:

        - ImportHandlerIdentifier
    .EXAMPLE
        $newImportItemRequestXMLObjectParams = @{
            ImportHandlerIdentifier = $ImportHandlerIdentifier
            NamespaceURI = $NamespaceURI
            NamespaceSchema = $NamespaceSchema
            EnvelopePrefix = $EnvelopePrefix
            RequestPrefix = $RequestPrefix
        }
        try {
            New-ImportItemRequestXMLObject @newImportItemRequestXMLObjectParams
        } catch {
            throw $_
        }
    .PARAMETER ImportHandlerIdentifier
        Value set as ImportHandlerIdentifier for request.
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
        This function sets a script variable named *ImportItemsRequest*.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceURI,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter(Mandatory)]
        [String]$ImportHandlerIdentifier,
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
        if ([string]::IsNullOrWhiteSpace($ImportHandlerIdentifier)) {
            throw "ImportHandlerIdentifier is null or empty"
        }
        if ($null -eq $requestXMLObject) {
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
        Write-Debug "Creating xml element for ImportItemsRequest"
        try {
            New-Variable -Name 'ImportItemsRequest' -Scope Script -Value (New-XMLElementObject -Name 'ImportItemsRequest' @newElementParams)
            $envelopeBody.AppendChild((Get-Variable -Name 'ImportItemsRequest' -ValueOnly)) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for ImportItemsRequest"
            throw $_
        }
        Write-Debug "Creating xml element for ImportHandlerIdentifier"
        try {
            $ImportItemsRequest.AppendChild((New-XMLElementObject -Name 'ImportHandlerIdentifier' -Value $ImportHandlerIdentifier @newElementParams)) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for ImportHandlerIdentifier"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}