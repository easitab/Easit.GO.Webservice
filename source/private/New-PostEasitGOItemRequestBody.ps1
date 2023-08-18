function New-PostEasitGOItemRequestBody {
    <#
    .SYNOPSIS
        Creates a JSON-formatted string.
    .DESCRIPTION
        **New-PostEasitGOItemsRequestBody** creates a JSON-formatted string from the provided input to use as body for a request sent to Easit GO WebAPI.
    .EXAMPLE
        $newGetEasitGOItemsRequestBodyParams = @{
            ImportHandlerIdentifier = $ImportHandlerIdentifier
            IDStart = $idStart
            Items = $adItems
        }
        New-PostEasitGOItemRequestBody @newGetEasitGOItemsRequestBodyParams
    .PARAMETER ImportHandlerIdentifier
        Name of importhandler to send items to.
    .PARAMETER Items
        Items to be added to itemToImport array.
    .PARAMETER IDStart
        Used as ID for first item in itemToImport array.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json.
    .OUTPUTS
        [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ImportHandlerIdentifier,
        [Parameter(Mandatory)]
        [Object[]]$Items,
        [Parameter()]
        [int]$IDStart,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
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
            $returnObject | Add-Member -MemberType NoteProperty -Name "importHandlerIdentifier" -Value $ImportHandlerIdentifier
        } catch {
            throw $_
        }
        try {
            $returnObject | Add-Member -MemberType NoteProperty -Name "itemToImport" -Value ([System.Collections.Generic.List[Object]]::new())
        } catch {
            throw $_
        }
        foreach ($item in $Items) {
            try {
                $itemToAdd = New-EasitGOItemToImport -Item $item -ID $IDStart
            } catch {
                throw $_
            }
            try {
                $returnObject.itemToImport.Add($itemToAdd)
            } catch {
                throw $_
            }
            $IDStart++
        }
        if ($null -eq $ConvertToJsonParameters) {
            $ConvertToJsonParameters = @{
                Depth = 4
                EscapeHandling = 'EscapeNonAscii'
                WarningAction = 'SilentlyContinue'
            }
        }
        try {
            Convert-ToEasitGOJson -InputObject $returnObject -Parameters $ConvertToJsonParameters
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}