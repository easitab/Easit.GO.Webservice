function New-GetReturnObject {
    <#
    .SYNOPSIS
        Creates an base PSCustomObject returned by *Convert-GetItemsResponse*.
    .DESCRIPTION
        **New-ReturnObject** creates a "base" object with some properties that a GetItemsResponse always contains.
    .EXAMPLE
        $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator() | ForEach-Object -Parallel {
            $xmlResponse = $using:Response
            try {
                $returnObject = New-ReturnObject -XML $xmlResponse
            } catch {
                throw $_
            }
        }
    .PARAMETER XML
        XML object to be used as basis for a new base object.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [XML]$XML
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $returnObject = New-Object PSCustomObject
        } catch {
            throw $_
        }
        try {
            $returnObject | Add-Member -MemberType NoteProperty -Name "RequestedPage" -Value "$($XML.Envelope.Body.GetItemsResponse.requestedPage)"
            $returnObject | Add-Member -MemberType NoteProperty -Name "TotalNumberOfPages" -Value "$($XML.Envelope.Body.GetItemsResponse.totalNumberOfPages)"
            $returnObject | Add-Member -MemberType NoteProperty -Name "TotalNumberOfItems" -Value "$($XML.Envelope.Body.GetItemsResponse.totalNumberOfItems)"
            $returnObject | Add-Member -MemberType NoteProperty -Name "DatabaseId" -Value "$($_.id)"
        } catch {
            throw $_
        }
        $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}