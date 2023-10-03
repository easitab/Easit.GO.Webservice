Class SortColumn {
    [String]$PropertyName
    [ValidateSet('Ascending','Descending')]
    [String]$Order
    SortColumn ($PropertyName,$Order) {
        $this.PropertyName = $PropertyName
        $this.Order = $Order
    }
    [PSCustomObject] ToPSCustomObject () {
        return [PSCustomObject]@{
            content = $this.PropertyName
            order = $this.Order
        }
    }
}