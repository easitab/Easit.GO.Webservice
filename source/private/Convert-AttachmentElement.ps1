function Convert-AttachmentElement {
    <#
    .SYNOPSIS
        Converts an attachment element to a PSCustomObject.
    .DESCRIPTION
        The **Convert-AttachmentElement** takes an XML element and creates a PSCustomObject from that element.
        The name attribute and innerText is used directly from the XML element. 

        **Convert-AttachmentElement** also adds a property named *ContentLength* to the return object with the value of
        *[element].InnerText.Length*.
    .EXAMPLE
        if ($ChildElement.LocalName -eq 'Attachment') {
            Convert-AttachmentElement -Attachment $ChildElement
        }
    .PARAMETER Attachment
        The XML element to be converted to a PSCustomObject
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$Attachment
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $convertedAttachmentElement = New-Object PSCustomObject
        try {
            $convertedAttachmentElement | Add-Member -MemberType NoteProperty -Name "Name" -Value $Attachment.name
        } catch {
            throw $_
        }
        try {
            $convertedAttachmentElement | Add-Member -MemberType NoteProperty -Name "Base64" -Value $Attachment.InnerText
        } catch {
            throw $_
        }
        try {
            $convertedAttachmentElement | Add-Member -MemberType NoteProperty -Name "ContentLength" -Value $Attachment.InnerText.Length
        } catch {
            throw $_
        }
        $convertedAttachmentElement
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}