function Send-ToEasitGO {
    <#
    .SYNOPSIS
        Send objects to Easit GO WebAPI.
    .DESCRIPTION
        Create or update any objects in Easit GO. This function can be used with any importhandler, module and object in Easit GO.
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        $customItem = @{prop1="value1";prop2="value2";prop3="value3"}
        Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com/integration-api'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        $csvData = Import-Csv -Path 'C:\Path\To\My\csvFile.csv'
        Send-ToEasitGO @sendToEasitParams -Item $csvData
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com/integration-api/items'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        $adObjects = Get-ADUser -Filter * -SearchBase 'OU=RootOU,DC=company,DC=com'
        Send-ToEasitGO @sendToEasitParams -Item $adObjects
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        Get-ADUser -Filter * -SearchBase 'OU=RootOU,DC=company,DC=com' | Send-ToEasitGO @sendToEasitParams
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        Import-Csv -Path 'C:\Path\To\My\csvFile.csv' | Send-ToEasitGO @sendToEasitParams -Item $csvData
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER ImportHandlerIdentifier
        ImportHandler to import data with.
    .PARAMETER Item
        Item or items to send to Easit GO.
    .PARAMETER CustomItem
        Hashtable of key-value-pair with the properties and its values that you want to send to Easit GO.
    .PARAMETER SendInBatchesOf
        Number of items to include in each request sent to Easit GO.
    .PARAMETER IDStart
        Used as ID for first item in itemToImport array.
    .PARAMETER InvokeRestMethodParameters
        Set of additional parameters for Invoke-RestMethod. Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json. Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.
    #>
    [OutputType('PSCustomObject')]
    [Alias('Import-GOCustomItem')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,Position=0,ParameterSetName='item')]
        [Parameter(Mandatory,Position=0,ParameterSetName='legacy')]
        [string]$Url,
        [Parameter(Mandatory,Position=1,ParameterSetName='item')]
        [Parameter(Mandatory,Position=1,ParameterSetName='legacy')]
        [string]$Apikey,
        [Parameter(Mandatory,Position=2,ParameterSetName='item')]
        [Parameter(Mandatory,Position=2,ParameterSetName='legacy')]
        [Alias('handler','ih','identifier')]
        [string]$ImportHandlerIdentifier,
        [Parameter(Mandatory=$true,ParameterSetName='item',ValueFromPipeline)]
        [Object[]]$Item,
        [Parameter(Mandatory=$true,ParameterSetName='legacy')]
        [System.Collections.Hashtable] $CustomItem,
        [Parameter(ParameterSetName='item')]
        [Parameter(ParameterSetName='legacy')]
        [int]$SendInBatchesOf = 50,
        [Parameter(ParameterSetName='item')]
        [Parameter(ParameterSetName='legacy')]
        [int]$IDStart = 1,
        [Parameter(ParameterSetName='item')]
        [Parameter(ParameterSetName='legacy')]
        [Alias('irmParams')]
        [System.Collections.Hashtable]$InvokeRestMethodParameters,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($Item.Count -eq 0 -and $null -eq $CustomItem) {
            Write-Warning "No items to send"
            return
        }
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Post
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOURL -URL $URL -Endpoint 'items'
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Credential = Get-EasitGOCredentialObject -Apikey $Apikey
        } catch {
            throw $_
        }
        if ($Item.Count -gt 0) {
            [int]$itemCount = $Item.Count
        }
        if (!($null -eq $CustomItem)) {
            [int]$itemCount = 1
        }
        try {
            $tempItemArray = [System.Collections.Generic.List[Object]]::new($itemCount)
        } catch {
            throw $_
        }
        if ($Item.Count -gt 0) {
            try {
                $tempItemArray.AddRange($Item)
            } catch {
                throw $_
            }
        }
        if (!($null -eq $CustomItem)) {
            try {
                $tempItemArray.Add(([PSCustomObject]$CustomItem))
            } catch {
                throw $_
            }
        }
        do {
            $newPostEasitGOItemsRequestBodyParams = @{
                ImportHandlerIdentifier = $ImportHandlerIdentifier
                IDStart = $IDStart
                Items = $null
                ConvertToJsonParameters = $ConvertToJsonParameters
            }
            if ($tempItemArray.Count -ge $SendInBatchesOf) {
                $newPostEasitGOItemsRequestBodyParams.Items = $tempItemArray.GetRange(0,$SendInBatchesOf)
            } else {
                $newPostEasitGOItemsRequestBodyParams.Items = $tempItemArray.GetRange(0,$tempItemArray.Count)
            }
            try {
                $baseRMParams.Body = New-PostEasitGOItemRequestBody @newPostEasitGOItemsRequestBodyParams
            } catch {
                throw $_
            }
            Write-Information "Sending $SendInBatchesOf items wih start at item $IDStart in array"
            if ($null -eq $InvokeRestMethodParameters) {
                try {
                    Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
                } catch {
                    throw $_
                }
            } else {
                try {
                    Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
                } catch {
                    throw $_
                }
            }
            if ($tempItemArray.Count -ge $SendInBatchesOf) {
                try {
                    $tempItemArray.RemoveRange(0,$SendInBatchesOf)
                } catch {
                    throw $_
                }
            } else {
                try {
                    $tempItemArray.RemoveRange(0,$tempItemArray.Count)
                } catch {
                    throw $_
                }
            }
            [int]$idStart = [int]$idStart + [int]$SendInBatchesOf
        } while ($tempItemArray.Count -gt 0)
    }
    end {
        [System.GC]::Collect()
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}