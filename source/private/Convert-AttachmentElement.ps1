function Convert-AttachmentElement {
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