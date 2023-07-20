function Convert-PropertyElement {
    <#
    .SYNOPSIS
        Converts a property element to a PSCustomObject.
    .DESCRIPTION
        The **Convert-AttachmentElement** takes an XML element and creates a PSCustomObject from that element.
        If the element is part of an array or collection, the name property will be ommited from the new object.

    .EXAMPLE
        if ($ChildElement.LocalName -eq 'Property') {
            Convert-PropertyElement -Property $ChildElement
        }
    .EXAMPLE
        if ($ChildElement.LocalName -eq 'Property') {
            Convert-PropertyElement -Property $ChildElement -ExcludeName
        }
    .PARAMETER Property
        The XML element to be converted to a PSCustomObject
    .PARAMETER ExcludeName
        Lets the function now if a property named Name should be added or not to the new object.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$Property,
        [Parameter()]
        [Switch]$ExcludeName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $convertedPropertyElement = New-Object PSCustomObject
        if ($ExcludeName) {
            Write-Debug "Parameter ExcludeName is provide, will not include Name in return object"
        } else {
            try {
                $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "Name" -Value $Property.name
            } catch {
                throw $_
            }
        }
        try {
            $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "Value" -Value $Property.InnerText
        } catch {
            throw $_
        }
        try {
            $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "RawValue" -Value $Property.rawValue
        } catch {
            throw $_
        }
        $convertedPropertyElement
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}