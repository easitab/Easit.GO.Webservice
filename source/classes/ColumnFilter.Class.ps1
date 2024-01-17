Class ColumnFilter {
    [String]$PropertyName
    [String]$RawValue
    [ValidatePattern("^[a-zA-Z_]+$")]
    [String]$Comparator
    [String]$PropertyValue
    ColumnFilter ($PropertyName,$RawValue,$Comparator,$PropertyValue) {
        $this.PropertyName = $PropertyName
        $this.RawValue = $RawValue
        $this.Comparator = $Comparator
        $this.PropertyValue = $PropertyValue
    }
    [PSCustomObject] ToPSCustomObject () {
        $returnObject = @{
            columnName = $this.PropertyName
            comparator = $this.Comparator
        }
        if ($this.RawValue) {
            $returnObject.Add('rawValue',$this.RawValue)
        }
        if ($this.PropertyValue) {
            $returnObject.Add('content',"$($this.PropertyValue)")
        }
        return [pscustomobject]$returnObject
    }
}