function Get-BaseRestMethodParameters {
    <#
    .SYNOPSIS
        Creates and returns a hashtable of the needed parameters for invoking *IRM*.
    .DESCRIPTION
        **Get-BaseRestMethodParameters** creates a hashtable with the parameters needed for running *Invoke-RestMethod* later.
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
        Hashtable
    #>
    [CmdletBinding(DefaultParameterSetName="Ping")]
    param (
        [Parameter(ParameterSetName="Ping")]
        [Switch]$Ping,
        [Parameter(Mandatory, ParameterSetName="Get")]
        [Switch]$Get,
        [Parameter(Mandatory, ParameterSetName="Post")]
        [Switch]$Post
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $returnObect = @{
                Uri = $null
                Method = $null
                ContentType = 'application/json'
            }
        } catch {
            throw $_
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
        if ($Post) {
            try {
                $returnObect.Method = 'POST'
            } catch {
                throw $_
            }
        } else {
            try {
                $returnObect.Method = 'GET'
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