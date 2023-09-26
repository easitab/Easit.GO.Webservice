function Get-BaseSoapRequestParameter {
    <#
    .SYNOPSIS
        Creates and returns a hashtable of the needed parameters for invoking *IRM*.
    .DESCRIPTION
        **Get-BaseRestMethodParameter** creates a hashtable with the parameters needed for running *Invoke-WebRequest*.
        Depending on what switches you provide, different keys will be added to the hashtable.
    .EXAMPLE
        Get-BaseSoapRequestParameter -ContentType

        Name                           Value
        ----                           -----
        Uri
        ContentType                    text/xml;charset=utf-8
    .EXAMPLE
        Get-BaseSoapRequestParameter -ContentType -ErrorHandling

        Name                           Value
        ----                           -----
        Uri
        ContentType                    text/xml;charset=utf-8
        ErrorAction                    Stop
    .EXAMPLE
        Get-BaseSoapRequestParameter -ContentType -ErrorHandling -NoUri

        Name                           Value
        ----                           -----
        ContentType                    text/xml;charset=utf-8
        ErrorAction                    Stop
    .PARAMETER Uri
        Specifies that a key for a Uri should be added to hashtable.
    .PARAMETER ContentType
        Specifies that a key for a ContentType should be added to hashtable.
    .PARAMETER ErrorHandling
        Specifies that a key for a ErrorHandling should be added to hashtable.
    .OUTPUTS
        [System.Collections.Specialized.OrderedDictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.specialized.ordereddictionary)
    #>
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]$NoUri,
        [Parameter()]
        [Switch]$ContentType,
        [Parameter()]
        [Switch]$ErrorHandling
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $returnObect = [ordered]@{}
        } catch {
            throw $_
        }
        if ($NoUri) {} else {
            try {
                $returnObect.Add('Uri',$null)
            } catch {
                throw $_
            }
        }
        if ($ContentType) {
            try {
                $returnObect.Add('ContentType','text/xml;charset=utf-8')
            } catch {
                throw $_
            }
        }
        if ($ErrorHandling) {
            try {
                $returnObect.Add('ErrorAction','Stop')
            } catch {
                throw $_
            }
        }
        return $returnObect
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}