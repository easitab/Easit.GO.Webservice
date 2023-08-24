function New-ColumnFilter {
    <#
    .SYNOPSIS
        Creates a new instance of the ColumnFilter class.
    .DESCRIPTION
        **New-ColumnFilter** acts as a wrapper function for the ColumnFilter class included in the module Easit.GO.Webservice.
        With the provided input it returns an instance of the ColumnFilter class.
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Description' -Comparator 'LIKE' -ColumnValue 'A description'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '73:1' -Comparator 'IN' -ColumnValue 'Registrered'
        } catch {
            throw $_
        }
    .PARAMETER ColumnName
        Name of the column / field to filter against.
    .PARAMETER RawValue
        The raw value (database id) for the value in the column / field.
    .PARAMETER Comparator
        What comparator to use and filter with.
    .PARAMETER ColumnValue
        String value for the column / field.
    .OUTPUTS
        [ColumnFilter](https://docs.easitgo.com/techspace/psmodules/)
    #>
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