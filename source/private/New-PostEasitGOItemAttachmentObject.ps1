function New-PostEasitGOItemAttachmentObject {
    <#
    .SYNOPSIS
        Creates a PropertyObject (PSCustomObject) from a property name and value.
    .DESCRIPTION
        **New-PostEasitGOItemAttachmentObject** creates a AttachmentObject (PSCustomObject) that should be added to the attachments array for a itemToImport item.
    .EXAMPLE
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            foreach ($attachment in $property.Value) {
                try {
                    $returnObject.attachment.Add((New-PostEasitGOItemAttachmentObject -InputObject $attachment))
                } catch {
                    throw $_
                }
            }
        }
    .PARAMETER InputObject
        Object with name and value to be used for new PSCustomObject.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrEmpty($InputObject.value) -and [string]::IsNullOrEmpty($InputObject.name)) {
            Write-Warning "Name and value for attachment is null, skipping.."
            return
        }
        try {
            [PSCustomObject]@{
                value = $InputObject.Value
                name = $InputObject.Name
                contentId = ((New-Guid).Guid).Replace('-','')
            }
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}