# New-GetEasitGODatasourceRequestBody

## SYNOPSIS
Creates a JSON-formatted string.

## SYNTAX

```
New-GetEasitGODatasourceRequestBody [-ModuleId] <Int32> [[-ParentRawValue] <String>]
 [[-ConvertToJsonParameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Creates a JSON-formatted string that can be used for making a GET request for data sources from Easit GO.

## EXAMPLES

### EXAMPLE 1
```
New-GetEasitGODatasourceRequestBody -ModuleId 1002
```

### EXAMPLE 2
```
New-GetEasitGODatasourceRequestBody -ModuleId 1002 -ParentRawValue '5:1'
```

## PARAMETERS

### -ConvertToJsonParameters
Set of additional parameters for ConvertTo-Json.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModuleId
Specifies the module id to get data sources from.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentRawValue
Specifies the id of a data sources (or entry in a data source tree) to get data sources from.

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

### [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
## NOTES

## RELATED LINKS
