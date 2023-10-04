---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-ImportClientConfigurationType

## SYNOPSIS
Returns the configuration type name.

## SYNTAX

```
Get-ImportClientConfigurationType [-Configuration] <XmlDocument> [<CommonParameters>]
```

## DESCRIPTION
The **Get-ImportClientConfigurationType** parses an XML document and the returns the name of the root element.

## EXAMPLES

### EXAMPLE 1
```
Get-ImportClientConfigurationType -Configuration $Configuration
ldapConfiguration
```

## PARAMETERS

### -Configuration
XML document to parse.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
