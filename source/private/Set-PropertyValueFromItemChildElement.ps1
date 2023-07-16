function Set-PropertyValueFromItemChildElement {
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