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
            $columnFilters += New-ColumnFilter -Property 'Description' -Comparator 'LIKE' -Value 'A description'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -Property 'Status' -RawValue '81:1' -Comparator 'IN'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -Property 'Status' -RawValue '73:1' -Comparator 'IN' -Value 'Registrered'
        } catch {
            throw $_
        }
    .PARAMETER Property
        Item property in Easit GO to filter on.
    .PARAMETER RawValue
        The raw value (database id) for the value in the item property.
    .PARAMETER Comparator
        What comparator to use and filter with.
    .PARAMETER Value
        Value to filter item property by.
    .OUTPUTS
        [ColumnFilter](https://docs.easitgo.com/techspace/psmodules/gowebservice/abouttopics/columnfilter/)
    #>
    [CmdletBinding(HelpUri = 'https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/newcolumnfilter/')]
    param (
        [Parameter(Mandatory)]
        [Alias('ColumnName','Name','PropertyName')]
        [String]$Property,
        [Parameter()]
        [String]$RawValue,
        [Parameter(Mandatory)]
        [ValidateSet('EQUALS','NOT_EQUALS','IN','NOT_IN','GREATER_THAN','GREATER_THAN_OR_EQUALS','LESS_THAN','LESS_THAN_OR_EQUALS','LIKE','NOT_LIKE')]
        [String]$Comparator,
        [Parameter()]
        [Alias('ColumnValue')]
        [String]$Value
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrWhiteSpace($RawValue) -and !([string]::IsNullOrWhiteSpace($Value))) {
            try {
                [ColumnFilter]::New($Property,$null,$Comparator,$Value)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($Value) -and !([string]::IsNullOrWhiteSpace($RawValue))) {
            try {
                [ColumnFilter]::New($Property,$RawValue,$Comparator,$null)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($RawValue) -and [string]::IsNullOrWhiteSpace($Value)) {
            if ([string]::IsNullOrWhiteSpace($Value)) {
                throw "ColumnValue is null or whitespace"
            }
            if ([string]::IsNullOrWhiteSpace($RawValue)) {
                throw "RawValue is null or whitespace"
            }
        } else {
            try {
                [ColumnFilter]::New($Property,$RawValue,$Comparator,$Value)
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}