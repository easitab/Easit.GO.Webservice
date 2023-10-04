function New-EasitGOItemToImport {
    <#
    .SYNOPSIS
        Creates a PSCustomObject that can be added to itemToImport.
    .DESCRIPTION
        **New-EasitGOItemToImport** creates a new PSCustomObject with properties and arrays in such a way that the result of *ConvertTo-Json -Item $myItem* is formatted as needed by the Easit GO WebAPI.

        The new PSCustomObject will have the following properties:
        - id (generated number unique for the item/object)
        - uid (generated value unique for the item/object)
        - property (array)
        - attachment (array)

        Each property returned by *$Item.psobject.properties.GetEnumerator()* will be added as a PSCustomObject to the property array.
        If the property returned by *$Item.psobject.properties.GetEnumerator()* has a name equal to *attachments* the property will be handled as an array of objects.
    .EXAMPLE
        $attachments = @(@{name='attachmentName';value='base64string'},@{name='attachmentName2';value='base64string2'})
        $myItem = [PSCustomObject]@{property1='propertyValue1';property2='propertyValue2';attachments=$attachments}
        New-EasitGOItemToImport -Item $myItem -ID 1
        id uid                              property                                                                               attachment
        -- ---                              --------                                                                               ----------
        1  0a65061df0814d6394736303587783f7 {@{content=propertyValue1; name=property1}, @{content=propertyValue2; name=property2}} {}
    .PARAMETER Item
        Item / Object to be added to *itemToImport* array.
    .PARAMETER ID
        ID to be set as id for item / object.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding(HelpUri = 'https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/neweasitgoitemtoimport/')]
    param (
        [Parameter(Mandatory)]
        [Object]$Item,
        [Parameter(Mandatory)]
        [int]$ID
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $returnObject = New-Object PSCustomObject
        } catch {
            throw $_
        }
        try {
            $returnObject | Add-Member -MemberType NoteProperty -Name "id" -Value $ID
            $returnObject | Add-Member -MemberType NoteProperty -Name "uid" -Value ((New-Guid).Guid).Replace('-','')
            $returnObject | Add-Member -MemberType NoteProperty -Name "property" -Value ([System.Collections.Generic.List[Object]]::new())
            $returnObject | Add-Member -MemberType NoteProperty -Name "attachment" -Value ([System.Collections.Generic.List[Object]]::new())
        } catch {
            throw $_
        }
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            if ($property.Name -eq 'attachments') {
                foreach ($attachment in $property.Value) {
                    try {
                        $returnObject.attachment.Add((New-PostEasitGOItemAttachmentObject -InputObject $attachment))
                    } catch {
                        throw $_
                    }
                }
            } else {
                if ($property.Value.GetType() -eq [System.Object[]]) {
                    foreach ($value in $property.Value.GetEnumerator()) {
                        try {
                            $returnObject.property.Add((
                                New-PostEasitGOItemPropertyObject -InputObject ([PSCustomObject]@{
                                    Name = $property.Name
                                    Value = $value
                                })
                            ))
                        } catch {
                            throw $_
                        }
                    }
                } else {
                    try {
                        $returnObject.property.Add((New-PostEasitGOItemPropertyObject -InputObject $property))
                    } catch {
                        throw $_
                    }
                }
            }
        }
        return $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}