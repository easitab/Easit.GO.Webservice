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