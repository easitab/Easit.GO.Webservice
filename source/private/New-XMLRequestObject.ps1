function New-XMLRequestObject {
    <#
    .SYNOPSIS
        Creates a base XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a new XML object with the elements 'Envelope', 'Header' and 'Body' and saves it to a variable named *xmlRequestObject* in the script scope.
        These elements are the baseline for any request sent to Easit GO.
    .EXAMPLE
        New-XMLRequestObject -NamespaceURI "http://schemas.xmlsoap.org/soap/envelope/" -NamespaceSchema "http://www.easit.com/bps/schemas"
    .PARAMETER NamespaceURI
        URI used for the envelope namespace (xmlns:soapenv).
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
    .OUTPUTS
        This function does not output anything.
        This function sets a script variable named *xmlRequestObject* ($script:xmlRequestObject).
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
            Write-Debug "Creating xml object for request"
            $script:xmlRequestObject = New-Object xml -ErrorAction Stop
        } catch {
            Write-Warning "Failed to create xml object for request"
            throw $_
        }
        try {
            Write-Debug "Adding XML declaration"
            [System.Xml.XmlDeclaration] $xmlDeclaration = $xmlRequestObject.CreateXmlDeclaration("1.0", "UTF-8", $null)
            $script:xmlRequestObject.AppendChild($xmlDeclaration) | Out-Null
        } catch {
            Write-Warning "Failed to add XML declaration"
            throw $_
        }
        try {
            Write-Debug "Creating xml element for Envelope"
            $soapEnvEnvelope = $xmlRequestObject.CreateElement("soapenv:Envelope","$NamespaceURI")
            $soapEnvEnvelope.SetAttribute("xmlns:sch","$NamespaceSchema")
            $script:xmlRequestObject.AppendChild($soapEnvEnvelope) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for Envelope"
            throw $_
        }
        try {
            Write-Debug "Creating xml element for Header"
            $soapEnvHeader = $xmlRequestObject.CreateElement('soapenv:Header',"$NamespaceURI")
            $soapEnvEnvelope.AppendChild($soapEnvHeader) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for Header"
            throw $_
        }
        try {
            Write-Debug "Creating xml element for Body"
            $script:soapEnvBody = $xmlRequestObject.CreateElement("soapenv:Body","$NamespaceURI")
            $soapEnvEnvelope.AppendChild($soapEnvBody) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for Body"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}