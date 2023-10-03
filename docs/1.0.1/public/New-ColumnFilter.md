# New-ColumnFilter

## SYNOPSIS
Creates a new instance of the ColumnFilter class.

## SYNTAX

```
New-ColumnFilter [-ColumnName] <String> [[-RawValue] <String>] [-Comparator] <String> [[-ColumnValue] <String>]
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
    $columnFilters += New-ColumnFilter -ColumnName 'Description' -Comparator 'LIKE' -ColumnValue 'A description'
} catch {
    throw $_
}
```

### EXAMPLE 2
```
$columnFilters = @()
try {
    $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
} catch {
    throw $_
}
```

### EXAMPLE 3
```
$columnFilters = @()
try {
    $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '73:1' -Comparator 'IN' -ColumnValue 'Registrered'
} catch {
    throw $_
}
```

## PARAMETERS

### -ColumnName
Name of the column / field to filter against.

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

### -ColumnValue
String value for the column / field.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### -RawValue
The raw value (database id) for the value in the column / field.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [ColumnFilter](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/columnfilter/)
## NOTES

## RELATED LINKS
