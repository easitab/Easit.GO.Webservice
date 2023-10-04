function Get-ImportClientConfigurationType {
    <#
    .SYNOPSIS
        Returns the configuration type name.
    .DESCRIPTION
        The **Get-ImportClientConfigurationType** parses an XML document and the returns the name of the root element.
    .EXAMPLE
        Get-ImportClientConfigurationType -Configuration $Configuration
        ldapConfiguration
    .PARAMETER Configuration
        XML document to parse.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType([System.String])]
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
            $configurationType = (Select-Xml -Xml $Configuration -XPath "*").Node.localname
        } catch {
            throw $_
        }
        $acceptedConfigTypes = @('ldapConfiguration','fileConfiguration','jdbcConfiguration')
        if ($acceptedConfigTypes -contains $configurationType) {
            return $configurationType
        } else {
            throw "Unable to get configuration type"
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}