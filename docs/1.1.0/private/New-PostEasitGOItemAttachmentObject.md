---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-PostEasitGOItemAttachmentObject

## SYNOPSIS
Creates a PropertyObject (PSCustomObject) from a property name and value.

## SYNTAX

```
New-PostEasitGOItemAttachmentObject [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
**New-PostEasitGOItemAttachmentObject** creates a AttachmentObject (PSCustomObject) that should be added to the attachments array for a itemToImport item.

## EXAMPLES

### EXAMPLE 1
```
foreach ($property in $Item.psobject.properties.GetEnumerator()) {
    foreach ($attachment in $property.Value) {
        try {
            $returnObject.attachment.Add((New-PostEasitGOItemAttachmentObject -InputObject $attachment))
        } catch {
            throw $_
        }
    }
}
```

## PARAMETERS

### -InputObject
Object with name and value to be used for new PSCustomObject.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
## NOTES

## RELATED LINKS
