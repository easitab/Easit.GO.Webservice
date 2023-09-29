# About SortColumn class

## DESCRIPTION

Initializes a new instance of the SortColumn class with the provided input.

## Constructors

* \[SortColumn\]::New(String,String)

## EXAMPLES

```powershell
    [SortColumn]::New($Name,$Order)
```

## Properties

### Name (String)

Name of field in Easit GO to sort on.

### Order (String)

Order to sort by.

Valid input is:

* Ascending
* Descending

## METHODS

### ToPSCustomObject

Returns a PSCustomObject representation of the instance with its properties and values.

```powershell
    return [PSCustomObject]@{
        content = $this.Name
        order = $this.Order
    }
```
