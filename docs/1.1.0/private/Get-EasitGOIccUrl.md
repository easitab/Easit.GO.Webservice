---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-EasitGOIccUrl

## SYNOPSIS
Combines an URL with a query string into one string.

## SYNTAX

```
Get-EasitGOIccUrl [-Url] <String> [-Query <String>] [<CommonParameters>]
```

## DESCRIPTION
The **Get-EasitGOIccUrl** uses the \[System.UriBuilder\](https://learn.microsoft.com/en-us/dotnet/api/system.uribuilder) class to construct an URL that can be sent to Easit GO for retrieving ImportClient configuration.

## EXAMPLES

### EXAMPLE 1
```
$queryParams = [ordered]@{
    apikey = $Apikey
    identifier = $Identifier
}
$queryString = New-UriQueryString -QueryParams $queryParams
Get-EasitGOIccUrl -URL $iccURL -Query $queryString
```

## PARAMETERS

### -Url
URL to combine with a query string.

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

### -Query
Query string to to combine with an URL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
## NOTES

## RELATED LINKS
