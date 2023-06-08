<#
.SYNOPSIS
    Initializes a new instance of the SortColumn class.
.DESCRIPTION
    Initializes a new instance of the SortColumn class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [SortColumn]::New(String,String)

    Available methods:
    - ConvertToXMLElement (Used by private functions)
.EXAMPLE
    [SortColumn]::New($Name,$Order)
.EXAMPLE
    $newElementParams = @{
        Prefix = $RequestPrefix
        NamespaceSchema = $NamespaceSchema
        ErrorAction = 'Stop'
    }
    $SortColumn.ConvertToXMLElement($newElementParams)
#>
Class SortColumn {
    [ValidatePattern("^[a-zA-Z]+$")]
    [String]$Name
    [ValidatePattern("^[a-zA-Z]+$")]
    [String]$Order
    SortColumn ($Name,$Order) {
        $this.Name = $Name
        $this.Order = $Order
    }
    [System.Xml.XmlElement] ConvertToXMLElement ([hashtable]$NewElementParams) {
        $sortColumnElementParams = @{
            Name = 'SortColumn'
            Value = $this.Name
            Attributes = [System.Collections.Generic.List[hashtable]]@(
                @{
                    LocalName = 'order'
                    Value = $this.Order
                }
            )
        }
        return (New-XMLElementObject @sortColumnElementParams @NewElementParams)
    }
}