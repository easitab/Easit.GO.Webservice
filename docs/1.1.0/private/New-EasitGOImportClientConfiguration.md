---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-EasitGOImportClientConfiguration

## SYNOPSIS
Creates a PSCustomObject from a configuration XML

## SYNTAX

```
New-EasitGOImportClientConfiguration [-Configuration] <XmlDocument> [<CommonParameters>]
```

## DESCRIPTION
The **New-EasitGOImportClientConfiguration** creates a new PSCustomObject from a configuration XML returned by Easit GO.

## EXAMPLES

### EXAMPLE 1
```
$response = Invoke-EasitGOXmlWebRequest -BaseParameters $baseIwrParams
New-EasitGOImportClientConfiguration -Configuration $response
```

## PARAMETERS

### -Configuration
XML configuration to create a PSCustomObject based on.

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

### [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
## NOTES

## RELATED LINKS
