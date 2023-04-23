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
            Attributes = @{
                order = $this.Order
            }
        }
        return (New-XMLElementObject @sortColumnElementParams @NewElementParams)
    }
}