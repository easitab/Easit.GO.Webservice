---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# New-ImportClientConfigurationInstance

## SYNOPSIS
Creates a new instance of a EasitGOImportClientConfiguration class.

## SYNTAX

```
New-ImportClientConfigurationInstance [-ConfigurationType] <String> [<CommonParameters>]
```

## DESCRIPTION
**New-ImportClientConfigurationInstance** acts as a wrapper function for the EasitGOImportClientConfiguration class included in the module Easit.GO.Webservice.
It returns an instance of the sub EasitGOImportClientConfiguration class for the configuration type.

## EXAMPLES

### EXAMPLE 1
```
$configurationInstance = New-ImportClientConfigurationInstance -ConfigurationType $configurationType
```

## PARAMETERS

### -ConfigurationType
{{ Fill ConfigurationType Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [EasitGOImportClientLdapConfiguration](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/easitgoimportclientldapconfiguration/)
### [EasitGOImportClientJdbcConfiguration](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/easitgoimportclientjdbcconfiguration/)
### [EasitGOImportClientXmlConfiguration](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/easitgoimportclientxmlconfiguration/)
## NOTES

## RELATED LINKS
