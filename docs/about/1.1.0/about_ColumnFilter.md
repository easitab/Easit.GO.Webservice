# About ColumnFilter class

## DESCRIPTION

Initializes a new instance of the ColumnFilter class with the provided input.

## Constructors

* \[ColumnFilter\]::New(String,String,String,String)

## EXAMPLES

```powershell
    [ColumnFilter]::New($PropertyName,$RawValue,$Comparator,$PropertyValue)
```

```powershell
    [ColumnFilter]::New($PropertyName,$null,$Comparator,$PropertyValue)
```

```powershell
    [ColumnFilter]::New($PropertyName,$RawValue,$Comparator,$null)
```

```powershell
    foreach ($columnFilter in $ColumnFilters) {
        $columnFilter.ToPSCustomObject()
    }
```

## Properties

|Name (Datatype)|Description|
|:--|:--|
|PropertyName (String)|Name of field in Easit GO to apply filter to|
|RawValue (String)|Database ID of item to filter for. Can be used instead of *ColumnValue* for a more exact filter result|
|Comparator (String)|Sets the comparator to use in filter|
|PropertyValue (String)|Value of the item property in Easit GO to filter for|

### Valid comparators

* EQUALS
* NOT_EQUALS
* IN
* NOT_IN
* GREATER_THAN
* GREATER_THAN_OR_EQUALS
* LESS_THAN
* LESS_THAN_OR_EQUALS
* LIKE
* NOT_LIKE

## METHODS

### ToPSCustomObject

Returns a PSCustomObject representation of the instance with its properties and values.

When creating the PSCustomObject representation of the instance, *PropertyValue* and *RawValue* will be excluded if its value is null.

```powershell
    $returnObject = @{
        columnName = $this.PropertyName
        comparator = $this.Comparator
    }
    if ($this.RawValue) {
        $returnObject.Add('rawValue',$this.RawValue)
    }
    if ($this.ColumnValue) {
        $returnObject.Add('content',"$($this.PropertyValue)")
    }
    return [pscustomobject]$returnObject
```
