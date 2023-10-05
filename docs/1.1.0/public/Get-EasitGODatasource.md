---
external help file: Easit.GO.Webservice-help.xml
Module Name: Easit.GO.Webservice
online version:
schema: 2.0.0
---

# Get-EasitGODatasource

## SYNOPSIS
Get datasources from Easit GO.

## SYNTAX

```
Get-EasitGODatasource [-Url] <String> [-Apikey] <String> [-ModuleId] <Int32> [[-ParentRawValue] <String>]
 [[-InvokeRestMethodParameters] <Hashtable>] [-ReturnAsSeparateObjects]
 [[-ConvertToJsonParameters] <Hashtable>] [-WriteBody] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
With **Get-EasitGODatasource** you can get datasources for a specific module from Easit GO.
If no *ParentRawValue* is provided the function returns the modules root datasources.

## EXAMPLES

### EXAMPLE 1
```
$getDatasourceFromEasitGO = @{
    Url = 'https://url.to.EasitGO'
    Apikey = 'myApiKey'
    ModuleId = 1001
}
Get-EasitGODatasource @getDatasourceFromEasitGO
```

In this example we want to get all datasources in the root in the module with id 1001.

### EXAMPLE 2
```
$getDatasourceFromEasitGO = @{
    Url = 'https://url.to.EasitGO'
    Apikey = 'myApiKey'
    ModuleId = 1001
    ParentRawValue = '5:1'
}
Get-EasitGODatasource @getDatasourceFromEasitGO
```

In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001.

### EXAMPLE 3
```
$getDatasourceFromEasitGO = @{
    Url = 'https://url.to.EasitGO'
    Apikey = 'myApiKey'
    ModuleId = 1001
    ParentRawValue = '5:1'
    ReturnAsSeparateObjects = $true
}
Get-EasitGODatasource @getDatasourceFromEasitGO
```

In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001 and we want them returned as separate objects.

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
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModuleId
Specifies what module to get datasources from.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentRawValue
Specifies what datasource to get child datasources from.
If not specified, root level datasources will be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvokeRestMethodParameters
Set of additional parameters for Invoke-RestMethod.
Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: irmParams

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnAsSeparateObjects
Specifies if *Get-EasitGOItem* should return each item in the view as its own PSCustomObject.

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

### -ConvertToJsonParameters
Set of additional parameters for ConvertTo-Json.
Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WriteBody
If specified the function will try to write the request body to a file in the current directory.

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
