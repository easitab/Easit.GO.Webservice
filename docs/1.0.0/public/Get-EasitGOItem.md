# Get-EasitGOItem

## SYNOPSIS
Get data from Easit GO.

## SYNTAX

```
Get-EasitGOItem [-Url] <String> [-Apikey] <String> [-ImportViewIdentifier] <String>
 [[-SortColumn] <SortColumn>] [[-Page] <Int32>] [[-PageSize] <Int32>] [[-ColumnFilter] <ColumnFilter[]>]
 [[-IdFilter] <String>] [[-FreeTextFilter] <String>] [[-InvokeRestMethodParameters] <Hashtable>] [-GetAllPages]
 [-ReturnAsSeparateObjects] [[-ConvertToJsonParameters] <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Sends an get request to the Easit GO WebAPI and returns the result of the request.

## EXAMPLES

### EXAMPLE 1
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 2
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    Page = 2
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 3
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    IdFilter = '4659:3'
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 4
```
$columnFilters = @()
$columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    ColumnFilter = $columnFilters
    PageSize = 500
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 5
```
$columnFilters = @()
$columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
$columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    ColumnFilter = $columnFilters
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 6
```
$columnFilters = @()
$columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
$columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
$sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    ColumnFilter = $columnFilters
    SortColumn = $sortColumn
}
Get-EasitGOItem @getEasitGOItemParams
```

### EXAMPLE 7
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
}
$easitObjects = Get-EasitGOItem @getEasitGOItemParams
foreach ($easitObject in $easitObjects.items.item.GetEnumerator()) {
    Write-Host "Got object with database id $($easitGOObject.id)"
    Write-Host "The object has the following properties and values"
    foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
        Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
    }
}
```

### EXAMPLE 8
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    GetAllPages = $true
}
$pages = Get-EasitGOItem @getEasitGOItemParams
foreach ($page in $pages) {
    foreach ($easitObject in $page.items.item.GetEnumerator()) {
        Write-Host "Got object with database id $($easitGOObject.id)"
        Write-Host "The object has the following properties and values"
        foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
            Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
        }
    }
}
```

### EXAMPLE 9
```
$getEasitGOItemParams = @{
    Url = 'https://go.easit.com'
    Apikey = 'myApikey'
    ImportViewIdentifier = 'myImportViewIdentifier'
    GetAllPages = $true
    ReturnAsSeparateObjects = $true
}
$easitObjects = Get-EasitGOItem @getEasitGOItemParams
foreach ($easitObject in $easitObjects.GetEnumerator()) {
    Write-Host "Got object with database id $($easitGOObject.id)"
    Write-Host "The object has the following properties and values"
    foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
        Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
    }
}
```

## PARAMETERS

### -Apikey
Apikey used for authenticating against Easit GO.

```yaml
Type: String
Parameter Sets: (All)
Aliases: api, key

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnFilter
Used to filter data.

```yaml
Type: ColumnFilter[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FreeTextFilter
Used to search a view with a text string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GetAllPages
Specifies if the function should try to get all pages from a view.

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

### -IdFilter
Database id for item to get.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportViewIdentifier
View to get data from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: view

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
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Page
Specifies what page in the view to get data from.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: viewPageNumber

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageSize
Specifies number of items each page returns.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
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

### -SortColumn
Used to sort data by a field / property and order (ascending / descending).

```yaml
Type: SortColumn
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
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
