# About SortColumn class

## DESCRIPTION

Initializes a new instance of the SortColumn class with the provided input.

## Constructors

* \[SortColumn\]::New(String,String)

## EXAMPLES

```powershell
    [SortColumn]::New($PropertyName,$Order)
```

## Properties

|Name (Datatype)|Description|
|:--|:--|
|PropertyName (String)|Name of field in Easit GO to apply filter to|
|Order (String)|Order to sort by|

### Valid sort orders

* Ascending
* Descending

## METHODS

### ToPSCustomObject

Returns a PSCustomObject representation of the instance with its properties and values.

```powershell
    return [PSCustomObject]@{
        content = $this.PropertyName
        order = $this.Order
    }
```
