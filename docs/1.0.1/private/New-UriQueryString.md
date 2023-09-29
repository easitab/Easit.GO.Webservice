# New-UriQueryString

## SYNOPSIS
Returns a hashtable as a query string

## SYNTAX

```
New-UriQueryString [-QueryParams] <OrderedDictionary> [<CommonParameters>]
```

## DESCRIPTION
The **New-UriQueryString** functions takes a ordered dictionary (hashtable) as input and uses *System.Web.HttpUtility* to build a query string from hashtable provided as input.

## EXAMPLES

### EXAMPLE 1
```
$queryParams = [ordered]@{
    apikey = 'myApiKey'
    identifier = 'identifier'
}
New-UriQueryString -QueryParams $queryParams
apikey=myApiKey&identifier=identifier
```

## PARAMETERS

### -QueryParams
{{ Fill QueryParams Description }}

```yaml
Type: OrderedDictionary
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
