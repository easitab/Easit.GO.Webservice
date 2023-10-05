function Test-EasitGOConnection {
    <#
    .SYNOPSIS
        Used to ping any Easit GO application using REST.
    .DESCRIPTION
        **Test-EasitGOConnection** can be use to check if a Easit GO application is up and running, supports REST and "reachable".
    .EXAMPLE
        Test-EasitGOConnection -URL 'https://test.easit.com'
    .PARAMETER URL
        URL to Easit GO application.
    .PARAMETER InvokeRestMethodParameters
        Additional parameters to be used by *Invoke-RestMethod*. Used to customize how *Invoke-RestMethod* behaves.
    .INPUTS
        None - You cannot pipe objects to this function
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding(HelpUri = 'https://docs.easitgo.com/techspace/psmodules/gowebservice/functions/testeasitgoconnection/')]
    param (
        [Parameter(Mandatory, Position=0)]
        [String]$URL,
        [Parameter()]
        [Alias('irmParams')]
        [hashtable]$InvokeRestMethodParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Ping
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOUrl -URL $URL -Endpoint 'ping'
        } catch {
            throw $_
        }
        if ($null -eq $InvokeRestMethodParameters) {
            try {
                Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
            } catch {
                throw $_
            }
        } else {
            try {
                Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}