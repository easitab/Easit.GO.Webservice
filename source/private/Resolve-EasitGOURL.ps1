function Resolve-EasitGOURL {
    <#
    .SYNOPSIS
        Resolves a URL so that is ends with '/integration-api/[endpoint]'
    .DESCRIPTION
        **Resolve-EasitGOURL** checks if the provided string ends with */integration-api/[endpoint]* and if not it adds the parts needed.
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com' -Leaf 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/' -Leaf 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api' -Leaf 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/' -Leaf 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/ping' -Leaf 'ping'
    .PARAMETER URL
        URL string that should be resolved.
    .PARAMETER Endpoint
        Endpoint that URL should be solved for.
    .OUTPUTS
        String
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [String]$URL,
        [Parameter(Mandatory, Position=1)]
        [String]$Endpoint
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $Endpoint = $Endpoint.ToLower()
        } catch {
            throw $_
        }
        if ($URL -match "/integration-api/$Endpoint") {
            return $URL
        }
        if ($URL -match '/integration-api$') {
            return "$URL" + "/$Endpoint"
        }
        if ($URL -match '/integration-api/$') {
            return "$URL" + "$Endpoint"
        }
        if ($URL -notmatch 'integration-api/?$') {
            if ($URL -match '/$') {
                return "$URL" + "integration-api/$Endpoint"
            } else {
                return "$URL" + "/integration-api/$Endpoint"
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}