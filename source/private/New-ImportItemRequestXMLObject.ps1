function New-ImportItemRequestXMLObject {
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
            $script:requestImportItemsRequestElement = $requestXMLObject.CreateElement("${RequestPrefix}:ImportItemsRequest","$NamespaceSchema")
            $requestBodyElement.AppendChild($requestImportItemsRequestElement) | Out-Null
        } catch {
            Write-Error "Failed to create xml element for ImportItemsRequest"
            Write-Error "$_"
            break
        }
        try {
            Write-Verbose "Creating xml element for Importhandler"
            $requestImportHandlerIdentifierElement = $requestXMLObject.CreateElement("${RequestPrefix}:ImportHandlerIdentifier","$NamespaceSchema")
            $requestImportHandlerIdentifierElement.InnerText  = "$ImportHandlerIdentifier"
            $requestImportItemsRequestElement.AppendChild($requestImportHandlerIdentifierElement) | Out-Null
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