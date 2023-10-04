---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-EasitGOItemToImport

## SYNOPSIS
Creates a PSCustomObject that can be added to itemToImport.

## SYNTAX

```
New-EasitGOItemToImport [-Item] <Object> [-ID] <Int32> [<CommonParameters>]
```

## DESCRIPTION
**New-EasitGOItemToImport** creates a new PSCustomObject with properties and arrays in such a way that the result of *ConvertTo-Json -Item $myItem* is formatted as needed by the Easit GO WebAPI.

The new PSCustomObject will have the following properties:
- id (generated number unique for the item/object)
- uid (generated value unique for the item/object)
- property (array)
- attachment (array)

Each property returned by *$Item.psobject.properties.GetEnumerator()* will be added as a PSCustomObject to the property array.
If the property returned by *$Item.psobject.properties.GetEnumerator()* has a name equal to *attachments* the property will be handled as an array of objects.

## EXAMPLES

### EXAMPLE 1
```
$attachments = @(@{name='attachmentName';value='base64string'},@{name='attachmentName2';value='base64string2'})
$myItem = [PSCustomObject]@{property1='propertyValue1';property2='propertyValue2';attachments=$attachments}
New-EasitGOItemToImport -Item $myItem -ID 1
id uid                              property                                                                               attachment
-- ---                              --------                                                                               ----------
1  0a65061df0814d6394736303587783f7 {@{content=propertyValue1; name=property1}, @{content=propertyValue2; name=property2}} {}
```

## PARAMETERS

### -Item
Item / Object to be added to *itemToImport* array.

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

### -ID
ID to be set as id for item / object.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
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
