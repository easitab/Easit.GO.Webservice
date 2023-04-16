Class ColumnFilter {
    [ValidatePattern("^[a-zA-Z0-9]+$")]
    [String]$ColumnName
    [String]$RawValue
    [ValidatePattern("^[a-zA-Z]+$")]
    [String]$Comparator
    [String]$ColumnValue
    ColumnFilter ($ColumnName,$RawValue,$Comparator,$ColumnValue) {
        $this.ColumnName = $ColumnName
        $this.RawValue = $RawValue
        $this.Comparator = $Comparator
        $this.ColumnValue = $ColumnValue
    }
}