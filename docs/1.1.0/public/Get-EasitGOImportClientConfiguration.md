---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-EasitGOImportClientConfiguration

## SYNOPSIS
Get a ImportClient configuration from Easit GO.

## SYNTAX

```
Get-EasitGOImportClientConfiguration [-Url] <String> [-Apikey] <String> [-Identifier] <String>
 [[-InvokeWebRequestParameters] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
With **Get-EasitGOImportClientConfiguration** you can get a configuration used by ImportClient.jar for retrieving object from external sources such as Active Directory or CSV-files.

## EXAMPLES

### EXAMPLE 1
```
$getIccConfigurationFromEasitGO = @{
    Url = 'https://url.to.EasitGO'
    Apikey = 'myApiKey'
    Identifier = 'myImportClientConfiguration'
}
$configuration = Get-EasitGOImportClientConfiguration @getIccConfigurationFromEasitGO
$adUsers = @()
foreach ($query in $configuration.queries) {
    $adUsers += Get-AdUser -LDAPFilter $query.filter
}
```

## PARAMETERS

### -Url
URL to Easit GO.

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

### -Apikey
Apikey used for authenticating to Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api, key

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identifier
Specifies the name of the configuration to get.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvokeWebRequestParameters
Set of additional parameters for Invoke-WebRequest.
Base parameters sent to Invoke-WebRequest is 'Uri', 'ContentType', 'ErrorAction'.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: iwrParams

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
