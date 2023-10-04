---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-BaseRestMethodParameter

## SYNOPSIS
Creates and returns a hashtable of the needed parameters for invoking *IRM*.

## SYNTAX

```
Get-BaseRestMethodParameter [-Ping] [-Get] [-Post] [<CommonParameters>]
```

## DESCRIPTION
**Get-BaseRestMethodParameter** creates a hashtable with the parameters needed for running *Invoke-RestMethod* later.
Depending on what action have been specified (Ping, Get or Post) different keys will be added to the hashtable.

## EXAMPLES

### EXAMPLE 1
```
Get-BaseRestMethodParameters -Ping
```

Name                           Value
----                           -----
Uri
Method                         GET
ContentType                    application/json

### EXAMPLE 2
```
Get-BaseRestMethodParameters -Get
```

Name                           Value
----                           -----
Uri
ContentType                    application/json
Body
Method                         GET
Authentication                 Basic
Credential

### EXAMPLE 3
```
Get-BaseRestMethodParameters -Post
```

Name                           Value
----                           -----
Uri
ContentType                    application/json
Body
Method                         POST
Authentication                 Basic
Credential

## PARAMETERS

### -Ping
Specifies that parameters for a ping request should be added to hashtable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Get
Specifies that parameters for a get request should be added to hashtable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Post
Specifies that parameters for a post request should be added to hashtable.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Collections.Hashtable](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables)
## NOTES

## RELATED LINKS
