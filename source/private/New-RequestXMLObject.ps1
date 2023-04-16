function New-RequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a new XML object with the elements 'Envelope', 'Header' and 'Body' and saves it to a variable named *requestXmlObject* in the script scope.
        These elements are the baseline for any request sent to Easit GO.
    .EXAMPLE
        New-RequestXMLObject -NamespaceURI "http://schemas.xmlsoap.org/soap/envelope/" -NamespaceSchema "http://www.easit.com/bps/schemas"
    .PARAMETER NamespaceURI
        URI used for the envelope namespace (xmlns:soapenv).
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
    .OUTPUTS
        This function does not output anything.
        This function sets a script variable named *requestXmlObject* ($script:requestXmlObject).
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
        [String]$RequestPrefix,
        [Parameter()]
        [String[]]$EnvelopeElements = @('Header','Body')
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
        try {
            Write-Debug "Creating xml object for request"
            New-Variable -Name 'requestXMLObject' -Scope Script -Value (New-Object XML -ErrorAction Stop)
        } catch {
            Write-Warning "Failed to create xml object for request"
            throw $_
        }
        try {
            Write-Debug "Creating XML declaration"
            [System.Xml.XmlDeclaration]$xmlDeclaration = $requestXMLObject.CreateXmlDeclaration("1.0", "UTF-8", $null)
        } catch {
            Write-Warning "Failed to create XML declaration"
            throw $_
        }
        try {
            Write-Debug "Adding XML declaration"
            $requestXMLObject.AppendChild($xmlDeclaration) | Out-Null
        } catch {
            Write-Warning "Failed to add XML declaration"
            throw $_
        }
        $envelopeParams = @{
            Name = 'Envelope'
            Prefix = $EnvelopePrefix
            NamespaceSchema = $NamespaceURI
            Attributes = @{
                "xmlns:${RequestPrefix}" = $NamespaceSchema
            }
        }
        try {
            Write-Debug "Creating xml element for Envelope"
            $requestRootElement = New-XMLElementObject @envelopeParams
            $requestXMLObject.AppendChild($requestRootElement) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for Envelope"
            throw $_
        }
        foreach ($EnvelopeElement in $EnvelopeElements) {
            Write-Debug "Creating xml element for $EnvelopeElement"
            $envelopeElementParams = @{
                Name = $EnvelopeElement
                Prefix = $EnvelopePrefix
                NamespaceSchema = $NamespaceURI
            }
            try {
                New-Variable -Name "request${EnvelopeElement}Element" -Scope Script -Value (New-XMLElementObject @envelopeElementParams)
                $requestRootElement.AppendChild((Get-Variable -Name "request${EnvelopeElement}Element" -ValueOnly)) | Out-Null
            } catch {
                Write-Warning "Failed to create xml element for $EnvelopeElement"
                throw $_
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}