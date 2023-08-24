# New-SortColumn

## SYNOPSIS
Creates a new instance of the SortColumn class.

## SYNTAX

```
New-SortColumn [-Name] <String> [-Order] <String> [<CommonParameters>]
```

## DESCRIPTION
**New-SortColumn** acts as a wrapper function for the SortColumn class included in the module Easit.GO.Webservice.
With the provided input it returns an instance of the SortColumn class.

## EXAMPLES

### EXAMPLE 1
```
$sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
```

## PARAMETERS

### -Name
Name of the column / field to sort by.

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

### -Order
Specifies if sort order should be descending or ascending.

```yaml
Type: String
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

### [SortColumn](https://docs.easitgo.com/techspace/psmodules/)
## NOTES

## RELATED LINKS
