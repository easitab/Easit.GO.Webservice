function Convert-PingResponse {
    <#
    .SYNOPSIS
        Function for converting items in a PingRequest XML response (PingResponse) to PSCustomObject.
    .DESCRIPTION
        
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