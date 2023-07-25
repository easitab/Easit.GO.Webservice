function New-RequestXMLObject {
    <#
    .SYNOPSIS
        Creates a base XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a new XML object with the elements 'Envelope', 'Header' and 'Body' and saves it to a variable named *requestXmlObject* in the script scope.
        These elements are the baseline for any request sent to Easit GO.
    .EXAMPLE
        $newRequestXMLObjectParams = @{
            NamespaceURI = $NamespaceURI
            NamespaceSchema = $NamespaceSchema
            EnvelopePrefix = $EnvelopePrefix
            RequestPrefix = $RequestPrefix
        }
        New-RequestXMLObject @newRequestXMLObjectParams
    .PARAMETER RequestPrefix
        Prefix used for elements appended to the Body element.
    .PARAMETER EnvelopePrefix
        Prefix used for elements appended to the Envelope element.
    .PARAMETER NamespaceURI
        URI used for the envelope namespace.
    .PARAMETER NamespaceSchema
        URI used for the body elements namespace.
    .PARAMETER EnvelopeElements
        Specifies what elements should be appended to the Envelope element.
    .OUTPUTS
        This function does not output anything.
        This function sets script variables named *requestXMLObject*, *envelopeBody* and *envelopeHeader*.
    .LINK
        - XmlDocument = https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument
        - CreateXmlDeclaration = https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument.createxmldeclaration
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
            Attributes = @(
                @{
                    LocalName = "xmlns:${RequestPrefix}"
                    Value = $NamespaceSchema
                }
            )
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
                New-Variable -Name "envelope${EnvelopeElement}" -Scope Script -Value (New-XMLElementObject @envelopeElementParams)
                $requestRootElement.AppendChild((Get-Variable -Name "envelope${EnvelopeElement}" -ValueOnly)) | Out-Null
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