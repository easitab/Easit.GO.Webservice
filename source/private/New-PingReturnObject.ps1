function New-PingReturnObject {
    <#
    .SYNOPSIS
        Creates an base PSCustomObject returned by *Convert-PingResponse*.
    .DESCRIPTION
        **New-PingReturnObject** creates a "base" object with some properties that a PingResponse always contains.
    .EXAMPLE
        try {
            New-PingReturnObject -XML $Response
        } catch {
            throw $_
        }
    .PARAMETER XML
        XML object to be used as basis for a new base object.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [XML]$XML
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $returnObject = New-Object PSCustomObject
        } catch {
            throw $_
        }
        foreach ($pingProperty in $XML.Envelope.Body.PingResponse.GetEnumerator()) {
            try {
                $returnObject | Add-Member -MemberType Noteproperty -Name "$($pingProperty.name)" -Value "$($pingProperty.InnerText)"
            } catch {
                throw $_
            }
        }
        $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}