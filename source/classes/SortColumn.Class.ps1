Class SortColumn {
    [ValidatePattern("^[a-zA-Z]+$")]
    [String]$Name
    [ValidatePattern("^[a-zA-Z]+$")]
    [String]$Order
    SortColumn ($Name,$Order) {
        $this.Name = $Name
        $this.Order = $Order
    }
}