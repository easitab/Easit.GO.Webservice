function Convert-ToEasitGOJson {
    <#
    .SYNOPSIS
        Converts an object to a JSON-formatted string.
    .DESCRIPTION
        **Convert-ToEasitGOJson** acts as a wrapper for *ConvertTo-Json* to make it easier to convert objects to a JSON-formatted, with "Easit GO flavour" string.
    .EXAMPLE
        $ConvertToJsonParameters = @{
            Depth = 4
            EscapeHandling = 'EscapeNonAscii'
            WarningAction = 'SilentlyContinue'
        }
        Convert-ToEasitGOJson -InputObject $object -Parameters $ConvertToJsonParameters
    .PARAMETER InputObject
        Object to convert to JSON string.
    .PARAMETER Parameters
        Hashtable of parameters for ConvertTo-Json.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject,
        [Parameter()]
        [System.Collections.Hashtable]$Parameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($null -eq $Parameters) {
            try {
                ConvertTo-Json -InputObject $InputObject
            } catch {
                throw $_
            }
        } else {
            try {
                ConvertTo-Json -InputObject $InputObject @Parameters
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}