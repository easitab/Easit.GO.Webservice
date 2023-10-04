---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Resolve-EasitGOUrl

## SYNOPSIS
Resolves a URL so that is ends with '/integration-api/\[endpoint\]'

## SYNTAX

```
Resolve-EasitGOUrl [-URL] <String> [-Endpoint] <String> [<CommonParameters>]
```

## DESCRIPTION
**Resolve-EasitGOUrl** checks if the provided string ends with */integration-api/\[endpoint\]* and if not it adds the parts needed.

## EXAMPLES

### EXAMPLE 1
```
Resolve-EasitGOUrl -URL 'https://test.easit.com' -Endpoint 'ping'
```

### EXAMPLE 2
```
Resolve-EasitGOUrl -URL 'https://test.easit.com/' -Endpoint 'ping'
```

### EXAMPLE 3
```
Resolve-EasitGOUrl -URL 'https://test.easit.com/integration-api' -Endpoint 'ping'
```

### EXAMPLE 4
```
Resolve-EasitGOUrl -URL 'https://test.easit.com/integration-api/' -Endpoint 'ping'
```

### EXAMPLE 5
```
Resolve-EasitGOUrl -URL 'https://test.easit.com/integration-api/ping' -Endpoint 'ping'
```

## PARAMETERS

### -URL
URL string that should be resolved.

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

### -Endpoint
Endpoint that URL should be solved for.

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

### [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
## NOTES

## RELATED LINKS
