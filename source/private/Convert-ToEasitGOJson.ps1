function Convert-ToEasitGOJson {
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