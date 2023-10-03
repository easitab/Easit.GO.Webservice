# Get-BaseSoapRequestParameter

## SYNOPSIS
Creates and returns a ordered dictionary (ordered hashtable) of the needed parameters for invoking *IWR*.

## SYNTAX

```
Get-BaseSoapRequestParameter [-NoUri] [-ContentType] [-ErrorHandling] [<CommonParameters>]
```

## DESCRIPTION
**Get-BaseRestMethodParameter** creates a ordered dictionary (ordered hashtable) with the parameters needed for running *Invoke-WebRequest*.
Depending on what switches you provide, different keys will be added to the hashtable.

## EXAMPLES

### EXAMPLE 1
```
Get-BaseSoapRequestParameter -ContentType
```

Name                           Value
----                           -----
Uri
ContentType                    text/xml;charset=utf-8

### EXAMPLE 2
```
Get-BaseSoapRequestParameter -ContentType -ErrorHandling
```

Name                           Value
----                           -----
Uri
ContentType                    text/xml;charset=utf-8
ErrorAction                    Stop

### EXAMPLE 3
```
Get-BaseSoapRequestParameter -ContentType -ErrorHandling -NoUri
```

Name                           Value
----                           -----
ContentType                    text/xml;charset=utf-8
ErrorAction                    Stop

## PARAMETERS

### -ContentType
Specifies that a key for a ContentType should be added.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorHandling
Specifies that a key for a ErrorHandling should be added.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoUri
{{ Fill NoUri Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Collections.Specialized.OrderedDictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.specialized.ordereddictionary)
## NOTES

## RELATED LINKS
