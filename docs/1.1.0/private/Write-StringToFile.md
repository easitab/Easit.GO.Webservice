---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Write-StringToFile

## SYNOPSIS
Sends a string to a file.

## SYNTAX

```
Write-StringToFile [-InputString] <String> [[-FilenamePrefix] <String>] [<CommonParameters>]
```

## DESCRIPTION
The **Write-StringToFile** function sends a string to a file.
If the file already exists a new file with a higher index number (following the naming format \\\[FilenamePrefix\\\]_payload_indexNumber.txt) will be created.

## EXAMPLES

### EXAMPLE 1
```
Write-StringToFile -InputString $baseRMParams.Body -FilenamePrefix 'GetEasitGOItem'
```

### EXAMPLE 2
```
Write-StringToFile -InputString $baseRMParams.Body -FilenamePrefix 'SendToEasitGO'
```

## PARAMETERS

### -InputString
String to write to a file.

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

### -FilenamePrefix
Prefix to set prepend to *_payload_indexNumber.txt*.
If not prefix is provided, file name will be *payload_indexNumber.txt*.

```yaml
Type: String
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

### None - This function returns no output.
## NOTES

## RELATED LINKS
