---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-EasitGOCredentialObject

## SYNOPSIS
Creates a PSCredential object.

## SYNTAX

```
Get-EasitGOCredentialObject [-Apikey] <String> [<CommonParameters>]
```

## DESCRIPTION
**Get-EasitGOCredentialObject** creates a credential object that can be used when sending requests to Easit GO WebAPI.

## EXAMPLES

### EXAMPLE 1
```
Get-EasitGOCredentialObject -Apikey $Apikey
```

UserName                     Password
--------                     --------
         System.Security.SecureString

## PARAMETERS

### -Apikey
APIkey used for authenticating to Easit GO WebAPI.

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

### [PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential)
## NOTES

## RELATED LINKS
