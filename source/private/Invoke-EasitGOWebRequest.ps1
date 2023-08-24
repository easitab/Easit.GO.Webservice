function Invoke-EasitGOWebRequest {
    <#
    .SYNOPSIS
        Sends an HTTP or HTTPS request to the Easit GO WebAPI.
    .DESCRIPTION
        **Invoke-EasitGOWebRequest** acts as a wrapper for *Invoke-RestMethod* to send a HTTP and HTTPS request to Easit GO WebAPI.

        When Easit GO WebAPI returns a JSON-string, *Invoke-RestMethod* converts, or deserializes, the content into PSCustomObject objects.
    .EXAMPLE
        Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
    .EXAMPLE
        $InvokeRestMethodParameters = @{
            TimeoutSec = 60
            SkipCertificateCheck = $true
        }
        Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
    .PARAMETER BaseParameters
        Set of "base parameters" needed for sending a request to Easit GO WebAPI.
        Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER CustomParameters
        Set of additional parameters for Invoke-RestMethod.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BaseParameters,
        [Parameter()]
        [hashtable]$CustomParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($null -eq $CustomParameters) {
            try {
                Invoke-RestMethod @BaseParameters
            } catch {
                throw $_
            }
        }
        if ($null -ne $CustomParameters ) {
            try {
                Invoke-RestMethod @BaseParameters @CustomParameters
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}