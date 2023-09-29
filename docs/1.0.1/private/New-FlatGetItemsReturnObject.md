# New-FlatGetItemsReturnObject

## SYNOPSIS
Creates an new PSCustomObject returned by *Convert-GetItemsResponse*.

## SYNTAX

```
New-FlatGetItemsReturnObject [-Response] <PSObject> [-Item] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
**New-FlatGetItemsReturnObject** creates a new "flat" PSCustomObject with all properties as members directly to the object.
Non "flat" PSCustomObject: $myObject.property.GetEnumerator() | | Where-Object -Property Name -EQ -Value 'wantedProperty'
"Flat" PSCustomObject: $myObject.wantedProperty

"Hidden" properties added to the returned PSCustomObject are:
* RequestedPage
* TotalNumberOfPages
* TotalNumberOfItems
* DatabaseId
* PropertyObjects
* propertyName_rawValue (one for each property)

If a property occurres more than one time, the property value will be an array of all values with that name.

## EXAMPLES

### EXAMPLE 1
```
$Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
    try {
        New-FlatGetItemsReturnObject -Response $using:Response -Item $_
    } catch {
        throw $_
    }
}
```

## PARAMETERS

### -Item
Item in response to be converted.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Response
Response to be used as basis for a new object.

```yaml
Type: PSObject
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
