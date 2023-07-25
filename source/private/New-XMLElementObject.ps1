function New-XMLElementObject {
    <#
    .SYNOPSIS
        Creates an XmlElement.
    .DESCRIPTION
        Creates an XmlElement from the XML document created by **New-RequestXMLObject**.
        If input is provided to the parameter *Attributes* that input will be used to set attribute names and values for the element.

        <sch:elementName>elementInnerText</sch:elementName>
    .EXAMPLE
        $newElementParams = @{
            Name = 'elementName'
            Prefix = 'soapenv'
            Value = 'elementInnerText'
            NamespaceSchema = 'http://schemas.xmlsoap.org/soap/envelope/'
        }
        PS > $xmlElement = New-XMLElementObject @newElementParams
    .EXAMPLE
        $newElementParams = @{
            Name = 'elementName'
            Prefix = 'sch'
            Value = 'elementInnerText'
            NamespaceSchema = 'http://www.easit.com/bps/schemas'
        }
        PS > $envelopeBody.AppendChild((New-XMLElementObject @newElementParams)) | Out-Null
    .PARAMETER Name
        The local name of the new element. ([prefix]:Name)
    .PARAMETER Value
        Value to be set as *InnerText* on the element.
    .PARAMETER Prefix
        The prefix of the new element. (Prefix:[Name])
    .PARAMETER NamespaceSchema
        The namespace URI of the new element
    .PARAMETER Attributes
        Hashtable with attributes and its values to be set for the element.
    .OUTPUTS
        XmlElement
    .LINK
        - XmlElement = https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmlelement
        - CreateElement = https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument.createelement
        - SetAttribute = https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmlelement.setattribute
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter()]
        [String]$Value,
        [Parameter(Mandatory)]
        [ValidateSet('soapenv','sch')]
        [String]$Prefix,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter()]
        [Hashtable[]]$Attributes
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            throw "Name is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($NamespaceSchema)) {
            throw "NamespaceSchema is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($Prefix)) {
            throw "Prefix is null or empty"
        }
        if ($null -eq $requestXMLObject) {
            throw "xmlRequestObject is null"
        }
        Write-Debug "Creating element with the specified Prefix ($Prefix), LocalName ($Name), and NamespaceURI ($NamespaceSchema)."
        try {
            $XMLElement = $requestXMLObject.CreateElement("$Prefix","$Name","$NamespaceSchema")
        } catch {
            throw $_
        }
        if (!([String]::IsNullOrWhiteSpace($Value))) {
            try {
                $XMLElement.InnerText = $Value
            } catch {
                throw $_
            }
        }
        foreach ($attribute in $Attributes) {
            try {
                $XMLElement.SetAttribute($attribute.LocalName,$attribute.Value)
            } catch {
                throw $_
            }
        }
        return $XMLElement
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}