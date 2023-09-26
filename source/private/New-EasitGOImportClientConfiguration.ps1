function New-EasitGOImportClientConfiguration {
    <#
    .SYNOPSIS
        Creates a PSCustomObject from a configuration XML
    .DESCRIPTION
        The **New-EasitGOImportClientConfiguration** creates a new PSCustomObject from a configuration XML returned by Easit GO.
    .EXAMPLE
        $response = Invoke-EasitGOXmlWebRequest -BaseParameters $baseIwrParams
        New-EasitGOImportClientConfiguration -Configuration $response
    .PARAMETER Configuration
        XML configuration to create a PSCustomObject based on.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Xml.XmlDocument]$Configuration
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $configurationType = Get-ImportClientConfigurationType -Configuration $Configuration
        } catch {
            throw $_
        }
        try {
            $configurationInstance = New-ImportClientConfigurationInstance -ConfigurationType $configurationType
        } catch {
            throw $_
        }
        try {
            $configurationInstance.SetPropertyValuesFromXml($Configuration)
        } catch {
            throw $_
        }
        try {
            return $configurationInstance.ToPSCustomObject()
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}