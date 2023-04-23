function New-ImportItemRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base ImportItemRequest XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a base ImportItemRequest XML object, based on the XML returned by *New-RequestXMLObject*.
        **New-ImportItemRequestXMLObject** checks if the variable *requestXMLObject* is null and if so calls **New-RequestXMLObject**
        to create a new request base XML object as value for the variable *requestXMLObject* in the script scope. It then adds the following elements:

        - ImportItemsRequest
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
        This function sets a script variable named *requestImportItemsRequestElement*.
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
            }
            try {
                New-RequestXMLObject @newRequestXMLObjectParams
            } catch {
                throw $_
            }
        }
        try {
            Write-Verbose "Creating xml element for ImportItemsRequest"
            $script:importItemsRequest = $requestXMLObject.CreateElement("${RequestPrefix}:ImportItemsRequest","$NamespaceSchema")
            $requestBodyElement.AppendChild($importItemsRequest) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ImportItemsRequest"
            Write-Error "$_"
            break
        }
        try {
            Write-Verbose "Creating xml element for Importhandler"
            $requestImportHandlerIdentifierElement = $requestXMLObject.CreateElement("${RequestPrefix}:ImportHandlerIdentifier","$NamespaceSchema")
            $requestImportHandlerIdentifierElement.InnerText  = "$ImportHandlerIdentifier"
            $importItemsRequest.AppendChild($requestImportHandlerIdentifierElement) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for Importhandler"
            Write-Error "$_"
            break
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}