<#
.SYNOPSIS
    Initializes a new instance of the ColumnFilter class.
.DESCRIPTION
    Initializes a new instance of the ColumnFilter class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [ColumnFilter]::New(String,String,String,String)

    Available methods:
    - ConvertToXMLElement (Used by private functions)
.EXAMPLE
    [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$ColumnValue)
.EXAMPLE
    $newElementParams = @{
        Prefix = $RequestPrefix
        NamespaceSchema = $NamespaceSchema
        ErrorAction = 'Stop'
    }
    foreach ($columnFilter in $ColumnFilters) {    
        $columnFilter.ConvertToXMLElement($newElementParams)
    }
#>
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
            Attributes = [System.Collections.Generic.List[hashtable]]@(
                @{
                    LocalName = 'columnName'
                    Value = $this.ColumnName
                },
                @{
                    LocalName = 'comparator'
                    Value = $this.Comparator
                }
            )
        }
        if ($this.RawValue) {
            $columnFilterElementParams.Attributes.Add(
                @{
                    LocalName = 'rawValue'
                    Value = "$($this.RawValue)"
                }
            )
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