---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-ColumnFilter

## SYNOPSIS
Creates a new instance of the ColumnFilter class.

## SYNTAX

```
New-ColumnFilter [-Property] <String> [[-RawValue] <String>] [-Comparator] <String> [[-Value] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
**New-ColumnFilter** acts as a wrapper function for the ColumnFilter class included in the module Easit.GO.Webservice.
With the provided input it returns an instance of the ColumnFilter class.

## EXAMPLES

### EXAMPLE 1
```
$columnFilters = @()
try {
    $columnFilters += New-ColumnFilter -Property 'Description' -Comparator 'LIKE' -Value 'A description'
} catch {
    throw $_
}
```

### EXAMPLE 2
```
$columnFilters = @()
try {
    $columnFilters += New-ColumnFilter -Property 'Status' -RawValue '81:1' -Comparator 'IN'
} catch {
    throw $_
}
```

### EXAMPLE 3
```
$columnFilters = @()
try {
    $columnFilters += New-ColumnFilter -Property 'Status' -RawValue '73:1' -Comparator 'IN' -Value 'Registrered'
} catch {
    throw $_
}
```

## PARAMETERS

### -Property
Item property in Easit GO to filter on.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ColumnName, Name, PropertyName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawValue
The raw value (database id) for the value in the item property.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comparator
What comparator to use and filter with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value to filter item property by.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ColumnValue

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

### [ColumnFilter](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/columnfilter/)
## NOTES

## RELATED LINKS
