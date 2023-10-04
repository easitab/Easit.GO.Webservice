---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Invoke-EasitGOWebRequest

## SYNOPSIS
Sends an HTTP or HTTPS request to the Easit GO WebAPI.

## SYNTAX

```
Invoke-EasitGOWebRequest [-BaseParameters] <Hashtable> [[-CustomParameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
**Invoke-EasitGOWebRequest** acts as a wrapper for *Invoke-RestMethod* to send a HTTP and HTTPS request to Easit GO WebAPI.

When Easit GO WebAPI returns a JSON-string, *Invoke-RestMethod* converts, or deserializes, the content into PSCustomObject objects.

## EXAMPLES

### EXAMPLE 1
```
Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
```

### EXAMPLE 2
```
$InvokeRestMethodParameters = @{
    TimeoutSec = 60
    SkipCertificateCheck = $true
}
Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
```

## PARAMETERS

### -BaseParameters
Set of "base parameters" needed for sending a request to Easit GO WebAPI.
Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomParameters
Set of additional parameters for Invoke-RestMethod.

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

### [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
## NOTES

## RELATED LINKS
