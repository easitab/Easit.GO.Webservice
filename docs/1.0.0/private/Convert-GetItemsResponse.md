# Convert-GetItemsResponse

## SYNOPSIS
Converts items in a GetItems JSON response to PSCustomObjects.

## SYNTAX

```
Convert-GetItemsResponse [-Response] <PSObject> [[-ThrottleLimit] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
**Convert-GetItemsResponse** converts each item in a GetItems JSON response to a PSCustomObject.

## EXAMPLES

### EXAMPLE 1
```
$response = Invoke-EasitGOWebRequest -url $url -api $api -body $body
Convert-GetItemsResponse -Response $reponse
```

## PARAMETERS

### -Response
Response object to convert

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThrottleLimit
Specifies the number of script blocks that run in parallel.
Input objects are blocked until the running script block count falls below the ThrottleLimit.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 5
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
