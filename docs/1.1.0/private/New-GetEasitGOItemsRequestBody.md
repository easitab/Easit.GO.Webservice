---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-GetEasitGOItemsRequestBody

## SYNOPSIS
Creates a JSON-formatted string.

## SYNTAX

```
New-GetEasitGOItemsRequestBody [-ImportViewIdentifier] <String> [[-SortColumn] <SortColumn>] [[-Page] <Int32>]
 [[-PageSize] <Int32>] [[-ColumnFilter] <ColumnFilter[]>] [[-IdFilter] <String>] [[-FreeTextFilter] <String>]
 [[-ConvertToJsonParameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
**New-GetEasitGOItemsRequestBody** creates a JSON-formatted string from the provided input to use as body for a request sent to Easit GO WebAPI.

## EXAMPLES

### EXAMPLE 1
```
$newGetEasitGOItemsRequestBodyParams = @{
    ImportViewIdentifier = 'example'
    Page = 2
    PageSize = 50
}
New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
{
    "pageSize": 50,
    "page": 2,
    "itemViewIdentifier": "example"
}
```

### EXAMPLE 2
```
$newGetEasitGOItemsRequestBodyParams = @{
    ImportViewIdentifier = 'example'
    Page = 3
    PageSize = 100
    ColumnFilter = $columnFilters
}
New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
{
    "pageSize": 100,
    "ColumnFilter": [
        {
            "comparator": "LIKE",
            "content": "b",
            "columnName": "Beskrivning"
        },
        {
            "comparator": "IN",
            "rawValue": "81:1",
            "columnName": "Status"
        }
    ],
    "page": 3,
    "itemViewIdentifier": "example"
}
```

## PARAMETERS

### -ImportViewIdentifier
View to get objects from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: itemViewIdentifier

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortColumn
Field / Column and order (Ascending / Descending) to sort objects by.

```yaml
Type: SortColumn
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
Used to get objects from a specific page in view.

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

### -PageSize
How many objects each page in view should return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnFilter
Field / Column to filter objects by.

```yaml
Type: ColumnFilter[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IdFilter
Database id for item to get.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FreeTextFilter
Filter view with a search string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
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
Position: 8
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
