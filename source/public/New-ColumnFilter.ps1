function New-ColumnFilter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$ColumnName,
        [Parameter()]
        [String]$RawValue,
        [Parameter(Mandatory)]
        [ValidateSet('EQUALS','NOT_EQUALS','IN','NOT_IN','GREATER_THAN','GREATER_THAN_OR_EQUALS','LESS_THAN','LESS_THAN_OR_EQUALS','LIKE','NOT_LIKE')]
        [String]$Comparator,
        [Parameter()]
        [String]$ColumnValue
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ([string]::IsNullOrWhiteSpace($RawValue) -and !([string]::IsNullOrWhiteSpace($ColumnValue))) {
            try {
                [ColumnFilter]::New($ColumnName,$null,$Comparator,$ColumnValue)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($ColumnValue) -and !([string]::IsNullOrWhiteSpace($RawValue))) {
            try {
                [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$null)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($RawValue) -and [string]::IsNullOrWhiteSpace($ColumnValue)) {
            if ([string]::IsNullOrWhiteSpace($ColumnValue)) {
                throw "ColumnValue is null or whitespace"
            }
            if ([string]::IsNullOrWhiteSpace($RawValue)) {
                throw "RawValue is null or whitespace"
            }
        } else {
            try {
                [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$ColumnValue)
            } catch {
                throw $_
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}