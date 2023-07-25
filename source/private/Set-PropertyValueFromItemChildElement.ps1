function Set-PropertyValueFromItemChildElement {
    <#
    .SYNOPSIS
        Set or add value for or to a property.
    .DESCRIPTION
        **Set-PropertyValueFromItemChildElement** takes the input for *ChildElement*, converts it to a PSCustomObject (with
        the help of *Convert-PropertyElement*) and sets that object as value for the property with the same name as ChildElement.name.
    .EXAMPLE
        $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator() | ForEach-Object -Parallel {
            $returnObject = New-ReturnObject -XML $xmlResponse
            foreach ($itemProperty in $_.GetEnumerator()) {
                $returnObject = Set-PropertyValueFromItemChildElement -ChildElement $itemProperty -InputObject $returnObject
            }
        }
    .PARAMETER ChildElement
        XmlElement to convert and set as value
    .PARAMETER InputObject
        PSCustomObject to set value for
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$ChildElement,
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($ChildElement.LocalName -eq 'Property') {
            $ChildElementName = "$($ChildElement.Name)"
            $propertyDetails = $InputObject."${ChildElementName}_details"
            if ($propertyDetails.IsArray -or $propertyDetails.IsCollection) {
                Write-Debug "Property $ChildElementName is an array"
                $InputObject."$ChildElementName".Add((Convert-PropertyElement -Property $ChildElement -ExcludeName))
            } else {
                Write-Debug "Property $ChildElementName is not an array"
                $InputObject."$ChildElementName" = (Convert-PropertyElement -Property $ChildElement -ExcludeName)
            }
        }
        if ($ChildElement.LocalName -eq 'Attachment') {
            if (!(Get-Member -InputObject $InputObject -Name 'Attachments')) {
                try {
                    $emptyList = [System.Collections.Generic.List[PSCustomObject]]::new()
                    $InputObject | Add-Member -MemberType NoteProperty -Name "Attachments" -Value $emptyList
                } catch {
                    throw $_
                }
            }
            try {
                $InputObject.Attachments.Add((Convert-AttachmentElement -Attachment $ChildElement))
            } catch {
                throw $_
            }
        }
        $InputObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}