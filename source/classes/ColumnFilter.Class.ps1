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
    [System.Xml.XmlElement] ConvertToXMLElement ([hashtable]$NewElementParams) {
        $columnFilterElementParams = @{
            Name = 'ColumnFilter'
            Attributes = [ordered]@{
                columnName = $this.ColumnName
                comparator = $this.Comparator
            }
        }
        if ($this.RawValue) {
            $columnFilterElementParams.Attributes.Add('rawValue',"$($this.RawValue)")
        }
        if ($this.ColumnValue) {
            $columnFilterElementParams.Add('Value',"$($this.ColumnValue)")
        }
        try {
            return (New-XMLElementObject @columnFilterElementParams @newElementParams)
        } catch {
            Write-Warning "Failed to create xml element for IdFilter"
            throw $_
        }
    }
}