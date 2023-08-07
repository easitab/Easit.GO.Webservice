<#
.SYNOPSIS
    Initializes a new instance of the SortColumn class.
.DESCRIPTION
    Initializes a new instance of the SortColumn class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [SortColumn]::New(String,String)

    Available methods:
    - ToPSCustomObject (Used by private functions)
.EXAMPLE
    $SortColumn = [SortColumn]::New($Name,$Order)
.EXAMPLE
    $SortColumn.ConvertToPSCustomObject()
#>
Class SortColumn {
    [String]$Name
    [ValidateSet('Ascending','Descending')]
    [String]$Order
    SortColumn ($Name,$Order) {
        $this.Name = $Name
        $this.Order = $Order
    }
    [PSCustomObject] ToPSCustomObject () {
        return [PSCustomObject]@{
            content = $this.Name
            order = $this.Order
        }
    }
}