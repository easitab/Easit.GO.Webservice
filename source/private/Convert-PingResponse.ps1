function Convert-PingResponse {
    <#
    .SYNOPSIS
        Function for converting items in a PingRequest XML response (PingResponse) to PSCustomObject.
    .DESCRIPTION
        **Convert-PingResponse** takes the ping response XML and returns a PSCustomObject with each childelement
        to Envelope.Body.PingResponse as a property.
    .EXAMPLE
        $response = Invoke-EasitWebRequest -url $url -api $api -body $body
        Convert-PingResponse -Response $reponse
    .PARAMETER Response
        XML response to convert
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [xml]$Response
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!($Response.Envelope.Body.PingResponse)) {
            Write-Warning "Ping reponse is empty"
            return
        }
        try {
            New-PingReturnObject -XML $Response
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}