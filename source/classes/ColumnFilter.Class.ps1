<#
.SYNOPSIS
    Initializes a new instance of the ColumnFilter class.
.DESCRIPTION
    Initializes a new instance of the ColumnFilter class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [ColumnFilter]::New(String,String,String,String)

    Available methods:
    - ToPSCustomObject (Used by private functions)
.EXAMPLE
    [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$ColumnValue)
.EXAMPLE
    foreach ($columnFilter in $ColumnFilters) {
        $columnFilter.ToPSCustomObject()
    }
#>
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