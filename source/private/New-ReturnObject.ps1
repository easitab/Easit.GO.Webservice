function New-ReturnObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [XML]$XML
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $returnObject = New-Object PSCustomObject
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