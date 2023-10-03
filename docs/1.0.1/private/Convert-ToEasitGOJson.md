# Convert-ToEasitGOJson

## SYNOPSIS
Converts an object to a JSON-formatted string.

## SYNTAX

```
Convert-ToEasitGOJson [-InputObject] <PSObject> [[-Parameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
**Convert-ToEasitGOJson** acts as a wrapper for *ConvertTo-Json* to make it easier to convert objects to a JSON-formatted, with "Easit GO flavour" string.

## EXAMPLES

### EXAMPLE 1
```
$ConvertToJsonParameters = @{
    Depth = 4
    EscapeHandling = 'EscapeNonAscii'
    WarningAction = 'SilentlyContinue'
}
Convert-ToEasitGOJson -InputObject $object -Parameters $ConvertToJsonParameters
```

## PARAMETERS

### -InputObject
Object to convert to JSON string.

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

### -Parameters
Hashtable of parameters for ConvertTo-Json.

```yaml
Type: Hashtable
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
