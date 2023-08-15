function Get-BaseRestMethodParameter {
    <#
    .SYNOPSIS
        Creates and returns a hashtable of the needed parameters for invoking *IRM*.
    .DESCRIPTION
        **Get-BaseRestMethodParameter** creates a hashtable with the parameters needed for running *Invoke-RestMethod* later.
        Depending on what action have been specified (Ping, Get or Post) different keys will be added to the hashtable.
    .EXAMPLE
        Get-BaseRestMethodParameters -Ping

        Name                           Value
        ----                           -----
        Uri
        Method                         GET
        ContentType                    application/json
    .EXAMPLE
        Get-BaseRestMethodParameters -Get

        Name                           Value
        ----                           -----
        Uri
        ContentType                    application/json
        Body
        Method                         GET
        Authentication                 Basic
        Credential
    .EXAMPLE
        Get-BaseRestMethodParameters -Post

        Name                           Value
        ----                           -----
        Uri
        ContentType                    application/json
        Body
        Method                         POST
        Authentication                 Basic
        Credential
    .PARAMETER Ping
        Specifies that parameters for a ping request should be added to hashtable.
    .PARAMETER Get
        Specifies that parameters for a get request should be added to hashtable.
    .PARAMETER Post
        Specifies that parameters for a post request should be added to hashtable.
    .OUTPUTS
        [System.Collections.Hashtable](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables)
    #>
    [OutputType('System.Collections.Hashtable')]
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]$Ping,
        [Parameter()]
        [Switch]$Get,
        [Parameter()]
        [Switch]$Post
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if (!($Ping) -and !($Get) -and !($Post)) {            
            throw "No request type specified"
        }
        try {
            $returnObect = [System.Collections.Hashtable]@{
                Uri = $null
                ContentType = 'application/json'
            }
        } catch {
            throw $_
        }
        if ($Post) {
            try {
                $returnObect.Add('Method','Post')
            } catch {
                throw $_
            }
        } else {
            try {
                $returnObect.Add('Method','Get')
            } catch {
                throw $_
            }
        }
        if ($Get -or $Post) {
            try {
                $returnObect.Add('Body',$null)
            } catch {
                throw $_
            }
            try {
                $returnObect.Add('Authentication','Basic')
            } catch {
                throw $_
            }
            try {
                $returnObect.Add('Credential',$null)
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