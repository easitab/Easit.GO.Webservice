# Send-ToEasitGO

## SYNOPSIS
Send one or more objects to Easit GO WebAPI.

## SYNTAX

### legacy
```
Send-ToEasitGO [-Url] <String> [-Apikey] <String> [-ImportHandlerIdentifier] <String> -CustomItem <Hashtable>
 [-SendInBatchesOf <Int32>] [-IDStart <Int32>] [-InvokeRestMethodParameters <Hashtable>]
 [-ConvertToJsonParameters <Hashtable>] [<CommonParameters>]
```

### item
```
Send-ToEasitGO [-Url] <String> [-Apikey] <String> [-ImportHandlerIdentifier] <String> -Item <Object[]>
 [-SendInBatchesOf <Int32>] [-IDStart <Int32>] [-InvokeRestMethodParameters <Hashtable>]
 [-ConvertToJsonParameters <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Create or update any object or objects in Easit GO.
This function can be used with any importhandler, module and object in Easit GO.

## EXAMPLES

### EXAMPLE 1
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
$customItem = @{prop1="value1";prop2="value2";prop3="value3"}
Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
```

### EXAMPLE 2
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com/integration-api'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
    SendInBatchesOf = 75
}
$csvData = Import-Csv -Path 'C:\Path\To\My\csvFile.csv' -Delimiter ';' -Encoding 'utf8'
Send-ToEasitGO @sendToEasitParams -Item $csvData
```

### EXAMPLE 3
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com/integration-api/items'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
$adObjects = Get-ADUser -Filter * -SearchBase 'OU=RootOU,DC=company,DC=com'
Send-ToEasitGO @sendToEasitParams -Item $adObjects
```

### EXAMPLE 4
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
Get-ADUser -Filter * -SearchBase 'OU=RootOU,DC=company,DC=com' | Send-ToEasitGO @sendToEasitParams
```

### EXAMPLE 5
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
Import-Csv -Path 'C:\Path\To\My\csvFile.csv' -Delimiter ';' -Encoding 'utf8' | Send-ToEasitGO @sendToEasitParams
```

### EXAMPLE 6
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
$customItem = @{
    prop1=@('value1','value4','value5')
    prop2="value2"
    prop3="value3"
}
Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
```

### EXAMPLE 7
```
$sendToEasitParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportHandlerIdentifier = 'myImportHandler'
}
$customItem = @{
    prop1=@{
        name = 'propertyNameUsedAsnameInJSON'
        value = 'propertyValue'
        rawValue = 'propertyRawValue'
    }
    prop2="value2"
    prop3="value3"
}
Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
```

## PARAMETERS

### -Apikey
Apikey used for authenticating against Easit GO.

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

### -ConvertToJsonParameters
Set of additional parameters for ConvertTo-Json.
Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomItem
Hashtable of key-value-pair with the properties and its values that you want to send to Easit GO.

```yaml
Type: Hashtable
Parameter Sets: legacy
Aliases: CustomProperties

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IDStart
Used as ID for first item in itemToImport array.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportHandlerIdentifier
ImportHandler to import data with.

```yaml
Type: String
Parameter Sets: (All)
Aliases: handler, ih, identifier

Required: True
Position: 3
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Item
Item or items to send to Easit GO.

```yaml
Type: Object[]
Parameter Sets: item
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -SendInBatchesOf
Number of items to include in each request sent to Easit GO.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
## NOTES

## RELATED LINKS
