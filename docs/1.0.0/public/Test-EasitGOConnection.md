# Test-EasitGOConnection

## SYNOPSIS
Used to ping any Easit GO application using REST.

## SYNTAX

```
Test-EasitGOConnection [-URL] <String> [-InvokeRestMethodParameters <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
**Test-EasitGOConnection** can be use to check if a Easit GO application is up and running, supports REST and "reachable".

## EXAMPLES

### EXAMPLE 1
```
Test-EasitGOConnection -URL 'https://test.easit.com'
```

## PARAMETERS

### -InvokeRestMethodParameters
Additional parameters to be used by *Invoke-RestMethod*.
Used to customize how *Invoke-RestMethod* behaves.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: irmParams

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
URL to Easit GO application.

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

### [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
## NOTES

## RELATED LINKS
