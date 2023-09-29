Class ColumnFilter {
    [String]$ColumnName
    [String]$RawValue
    [ValidatePattern("^[a-zA-Z_]+$")]
    [String]$Comparator
    [String]$ColumnValue
    ColumnFilter ($ColumnName,$RawValue,$Comparator,$ColumnValue) {
        $this.ColumnName = $ColumnName
        $this.RawValue = $RawValue
        $this.Comparator = $Comparator
        $this.ColumnValue = $ColumnValue
    }
    [PSCustomObject] ToPSCustomObject () {
        $returnObject = @{
            columnName = $this.ColumnName
            comparator = $this.Comparator
        }
        if ($this.RawValue) {
            $returnObject.Add('rawValue',$this.RawValue)
        }
        if ($this.ColumnValue) {
            $returnObject.Add('content',"$($this.ColumnValue)")
        }
        return [pscustomobject]$returnObject
    }
}