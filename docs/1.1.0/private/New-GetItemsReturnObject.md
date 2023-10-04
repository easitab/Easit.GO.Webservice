---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-GetItemsReturnObject

## SYNOPSIS
Creates an base PSCustomObject returned by *Convert-GetItemsResponse*.

## SYNTAX

```
New-GetItemsReturnObject [-Response] <PSObject> [-Item] <PSObject> [<CommonParameters>]
```

## DESCRIPTION
**New-GetItemsReturnObject** add a property named *viewDetails* with details such as RequestedPage, TotalNumberOfPages and TotalNumberOfItems to an item from a reponse object and returns it.

## EXAMPLES

### EXAMPLE 1
```
$Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
    try {
        New-GetItemsReturnObject -Response $using:Response -Item $_
    } catch {
        throw $_
    }
}
```

## PARAMETERS

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

### -Item
Item in response to be converted / updated.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
## NOTES

## RELATED LINKS
