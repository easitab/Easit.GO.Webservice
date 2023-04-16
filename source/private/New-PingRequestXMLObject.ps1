function New-PingRequestXMLObject {
    <#
    .SYNOPSIS
        Creates a XML object that can be used for sending a ping request to Easit GO.
    .DESCRIPTION
        Creates a new baseline XML request object with *New-PingRequestXMLObject* and add the *PingRequest* element to that object.
    .EXAMPLE 
        New-PingRequestXMLObject -NamespaceURI "http://schemas.xmlsoap.org/soap/envelope/" -NamespaceSchema "http://www.easit.com/bps/schemas"
    .PARAMETER NamespaceURI
        URI used for the envelope namespace (xmlns:soapenv).
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
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
        try {
            Write-Debug "Creating xml element for PingRequest"
            $requestPingRequestElement = New-XMLElementObject -Name 'PingRequest' -Prefix $RequestPrefix -Value '?' -NamespaceSchema $NamespaceSchema
            $requestBodyElement.AppendChild($requestPingRequestElement) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for PingRequest"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}