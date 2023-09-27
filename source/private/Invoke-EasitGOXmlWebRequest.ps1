function Invoke-EasitGOXmlWebRequest {
    <#
    .SYNOPSIS
        Sends an HTTP or HTTPS request to the Easit GO WebAPI.
    .DESCRIPTION
        **Invoke-EasitGOXmlWebRequest** acts as a wrapper for *Invoke-WebRequest* to send a HTTP or HTTPS request to Easit GO.
    .EXAMPLE
        Invoke-EasitGOXmlWebRequest -BaseParameters $baseRMParams
    .EXAMPLE
        $InvokeRestMethodParameters = @{
            TimeoutSec = 60
            SkipCertificateCheck = $true
        }
        Invoke-EasitGOXmlWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
    .PARAMETER BaseParameters
        Set of "base parameters" needed for sending a request to Easit GO WebAPI.
        Base parameters sent to Invoke-WebRequest is 'Uri','ContentType'.
    .PARAMETER CustomParameters
        Set of additional parameters for Invoke-WebRequest.
    .OUTPUTS
        [System.Xml.XmlDocument](https://learn.microsoft.com/en-us/dotnet/api/system.xml.xmldocument)
    #>
    [OutputType([System.Xml.XmlDocument])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Collections.Hashtable]$BaseParameters,
        [Parameter()]
        [System.Collections.Hashtable]$CustomParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($null -eq $CustomParameters) {
            try {
                $response = Invoke-WebRequest @BaseParameters
            } catch {
                throw $_
            }
        }
        if ($null -ne $CustomParameters ) {
            try {
                $response = Invoke-WebRequest @BaseParameters @CustomParameters
            } catch {
                throw $_
            }
        }
        try {
            [xml]$configurationXML = [System.Text.Encoding]::UTF8.GetString($response.Content)
        } catch {
            throw $_
        }
        return $configurationXML
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}