function New-PingRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a XML object that can be used for sending a ping request to Easit GO.
    .DESCRIPTION
        **New-PingRequestXMLObject** checks if the variable *xmlRequestObject* is null and if so calls **New-RequestXMLObject**.
        **New-PingRequestXMLObject** then creates a new *PingRequest* element and appends it to the envelope body element.
    .EXAMPLE 
        $newPingRequestXMLObjectParams = @{
            EnvelopePrefix = 'soapenv'
            RequestPrefix = 'sch'
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        New-PingRequestXMLObject @newPingRequestXMLObjectParams
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
        This function adds an element to the envelopes Body element.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceURI,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
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
                Name = 'PingRequest'
                Prefix = $RequestPrefix
                Value = '?'
                NamespaceSchema = $NamespaceSchema
            }
        } catch {
            Write-Warning "Failed to set newElementParams"
            throw $_
        }
        Write-Debug "Creating xml element for PingRequest"
        try {
            $envelopeBody.AppendChild((New-XMLElementObject @newElementParams)) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for PingRequest"
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}