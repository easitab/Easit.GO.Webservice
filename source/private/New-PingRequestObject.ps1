function New-PingRequestObject {
    <#
    .SYNOPSIS
        Creates a XML object that can be used for sending a ping request to Easit GO.
    .DESCRIPTION
        Creates a new baseline XML request object with *New-XMLRequestObject* and add the *PingRequest* element to that object.

        ```xml
        <soapenv:Envelope xmlns:sch="http://www.easit.com/bps/schemas" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
            <soapenv:Header />
            <soapenv:Body>
                <sch:PingRequest>?</sch:PingRequest>
            </soapenv:Body>
        </soapenv:Envelope>
        ```
    .EXAMPLE 
        New-XMLRequestObject -NamespaceURI "http://schemas.xmlsoap.org/soap/envelope/" -NamespaceSchema "http://www.easit.com/bps/schemas"
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
        [String]$NamespaceSchema
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
        try {
            New-XMLRequestObject -NamespaceURI $NamespaceURI -NamespaceSchema $NamespaceSchema
        } catch {
            throw $_
        }
        try {
            Write-Debug "Creating xml element for PingRequest"
            $envelopePingRequest = $xmlRequestObject.CreateElement('sch:PingRequest',"$NamespaceSchema")
            $envelopePingRequest.InnerText  = '?'
            $soapEnvBody.AppendChild($envelopePingRequest) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for PingRequest"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}