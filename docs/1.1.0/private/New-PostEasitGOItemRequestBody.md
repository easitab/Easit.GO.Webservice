---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-PostEasitGOItemRequestBody

## SYNOPSIS
Creates a JSON-formatted string.

## SYNTAX

```
New-PostEasitGOItemRequestBody [-ImportHandlerIdentifier] <String> [-Items] <Object[]> [[-IDStart] <Int32>]
 [[-ConvertToJsonParameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
**New-PostEasitGOItemsRequestBody** creates a JSON-formatted string from the provided input to use as body for a request sent to Easit GO WebAPI.

## EXAMPLES

### EXAMPLE 1
```
$newGetEasitGOItemsRequestBodyParams = @{
    ImportHandlerIdentifier = $ImportHandlerIdentifier
    IDStart = $idStart
    Items = $adItems
}
New-PostEasitGOItemRequestBody @newGetEasitGOItemsRequestBodyParams
```

## PARAMETERS

### -ImportHandlerIdentifier
Name of importhandler to send items to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
Items to be added to itemToImport array.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IDStart
Used as ID for first item in itemToImport array.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConvertToJsonParameters
Set of additional parameters for ConvertTo-Json.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
## NOTES

## RELATED LINKS
