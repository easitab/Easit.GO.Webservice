function Get-EasitGOCredentialObject {
    <#
    .SYNOPSIS
        Creates a PSCredential object.
    .DESCRIPTION
        **Get-EasitGOCredentialObject** creates a credential object that can be used when sending requests to Easit GO WebAPI.
    .EXAMPLE
        Get-EasitGOCredentialObject -Apikey $Apikey

        UserName                     Password
        --------                     --------
                 System.Security.SecureString
    .PARAMETER Apikey
        APIkey used for authenticating to Easit GO WebAPI.
    .OUTPUTS
        [PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential)
    #>
    [OutputType('PSCredential')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Apikey
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            [securestring]$secString = ConvertTo-SecureString $Apikey -AsPlainText -Force
        } catch {
            throw $_
        }
        try {
            New-Object System.Management.Automation.PSCredential ($Apikey, $secString)
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}