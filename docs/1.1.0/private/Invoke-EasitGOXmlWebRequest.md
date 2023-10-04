---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Invoke-EasitGOXmlWebRequest

## SYNOPSIS
Sends an HTTP or HTTPS request to the Easit GO WebAPI.

## SYNTAX

```
Invoke-EasitGOXmlWebRequest [-BaseParameters] <Hashtable> [[-CustomParameters] <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
**Invoke-EasitGOXmlWebRequest** acts as a wrapper for *Invoke-WebRequest* to send a HTTP or HTTPS request to Easit GO.

## EXAMPLES

### EXAMPLE 1
```
Invoke-EasitGOXmlWebRequest -BaseParameters $baseRMParams
```

### EXAMPLE 2
```
$InvokeRestMethodParameters = @{
    TimeoutSec = 60
    SkipCertificateCheck = $true
}
Invoke-EasitGOXmlWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
```

## PARAMETERS

### -BaseParameters
Set of "base parameters" needed for sending a request to Easit GO WebAPI.
Base parameters sent to Invoke-WebRequest is 'Uri','ContentType'.

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
Set of additional parameters for Invoke-WebRequest.

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

### [System.Xml.XmlDocument](https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument)
## NOTES

## RELATED LINKS
