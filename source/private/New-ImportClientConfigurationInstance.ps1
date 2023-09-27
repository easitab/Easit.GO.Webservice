function New-ImportClientConfigurationInstance {
    <#
    .SYNOPSIS
        Creates a new instance of a EasitGOImportClientConfiguration class.
    .DESCRIPTION
        **New-ImportClientConfigurationInstance** acts as a wrapper function for the EasitGOImportClientConfiguration class included in the module Easit.GO.Webservice.
        It returns an instance of the sub EasitGOImportClientConfiguration class for the configuration type.
    .EXAMPLE
        $configurationInstance = New-ImportClientConfigurationInstance -ConfigurationType $configurationType
    .OUTPUTS
        [EasitGOImportClientLdapConfiguration](https://docs.easitgo.com/techspace/psmodules/)
        [EasitGOImportClientJdbcConfiguration](https://docs.easitgo.com/techspace/psmodules/)
        [EasitGOImportClientXmlConfiguration](https://docs.easitgo.com/techspace/psmodules/)
    #>
    [OutputType()]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$ConfigurationType
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($ConfigurationType -eq 'ldapConfiguration') {
            try {
                [EasitGOImportClientLdapConfiguration]::New()
            } catch {
                throw $_
            }
        } elseif ($ConfigurationType -eq 'jdbcConfiguration') {
            try {
                [EasitGOImportClientJdbcConfiguration]::New()
            } catch {
                throw $_
            }
        } elseif ($ConfigurationType -eq 'fileConfiguration') {
            try {
                [EasitGOImportClientXmlConfiguration]::New()
            } catch {
                throw $_
            }
        } else {
            throw "Unknown configuration type"
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}