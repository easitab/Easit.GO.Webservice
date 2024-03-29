function New-GetEasitGODatasourceRequestBody {
    <#
    .SYNOPSIS
        Creates a JSON-formatted string.
    .DESCRIPTION
        Creates a JSON-formatted string that can be used for making a GET request for data sources from Easit GO.
    .EXAMPLE
        New-GetEasitGODatasourceRequestBody -ModuleId 1002
    .EXAMPLE
        New-GetEasitGODatasourceRequestBody -ModuleId 1002 -ParentRawValue '5:1'
    .PARAMETER ModuleId
        Specifies the module id to get data sources from.
    .PARAMETER ParentRawValue
        Specifies the id of a data sources (or entry in a data source tree) to get data sources from.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$ModuleId,
        [Parameter()]
        [string]$ParentRawValue,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $bodyObject = @{}
        try {
            $bodyObject.Add('moduleId',$ModuleId)
        } catch {
            throw $_
        }
        if ($ParentRawValue) {
            try {
                $bodyObject.Add('parentRawValue',$ParentRawValue)
            } catch {
                throw $_
            }
        }
        if ($null -eq $ConvertToJsonParameters) {
            $ConvertToJsonParameters = @{
                Depth = 4
                EscapeHandling = 'EscapeNonAscii'
                WarningAction = 'SilentlyContinue'
            }
        }
        try {
            Convert-ToEasitGOJson -InputObject $bodyObject -Parameters $ConvertToJsonParameters
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}