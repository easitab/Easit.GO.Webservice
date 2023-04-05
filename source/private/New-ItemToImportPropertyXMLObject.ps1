function New-ItemToImportPropertyXMLObject {
    <#
    .SYNOPSIS
        Creates a property XML element that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a property XML element, assigns it to the script variable *schItemToImport*.
        The element will have a attribute called *name* with a value of the input for the Name parameter.
        If the Value parameter is null, no value for innerText is set. In all other cases we set the input for the Value parameter as innerText.

        if ($null -eq $Value -or $Value -eq $null) {
            
        } else {
            InnerText = $Value
        }
    .EXAMPLE
        foreach ($property in $InputObject.psobject.properties) {
            New-ItemToImportPropertyXMLObject -NamespaceSchema $NamespaceSchema -Name $property.Name -Value $property.Value
        }
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
    .PARAMETER Name
        Value to be set as value for name attribute.
    .PARAMETER Value
        Value to be set as innertext for element.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter()]
        [String]$Value
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            throw "Name is null or empty"
        }
        try {
            $envelopeItemProperty = $script:xmlRequestObject.CreateElement("sch:Property","$NamespaceSchema")
            $envelopeItemProperty.SetAttribute('name',"$Name")
        } catch {
            
        }
        if ($null -eq $Value -or $Value -eq $null) {
            
        } else {
            try {
                $envelopeItemProperty.InnerText = $Value
            } catch {
                Write-Warning "Failed to set property value"
                throw $_
            }
        }
        try {
            $script:schItemToImport.AppendChild($envelopeItemProperty) | Out-Null
        } catch {
            Write-Warning "Failed to add property $Name to request"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}