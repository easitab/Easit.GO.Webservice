<#
.SYNOPSIS
    Initializes a new instance of the ColumnFilter class.
.DESCRIPTION
    Initializes a new instance of the ColumnFilter class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [ColumnFilter]::New(String,String,String,String)

    Available methods:
    - ToPSCustomObject (Used by private functions)
.EXAMPLE
    [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$ColumnValue)
.EXAMPLE
    foreach ($columnFilter in $ColumnFilters) {
        $columnFilter.ToPSCustomObject()
    }
#>
Class ColumnFilter {
    [String]$ColumnName
    [String]$RawValue
    [ValidatePattern("^[a-zA-Z_]+$")]
    [String]$Comparator
    [String]$ColumnValue
    ColumnFilter ($ColumnName,$RawValue,$Comparator,$ColumnValue) {
        $this.ColumnName = $ColumnName
        $this.RawValue = $RawValue
        $this.Comparator = $Comparator
        $this.ColumnValue = $ColumnValue
    }
    [PSCustomObject] ToPSCustomObject () {
        $returnObject = @{
            columnName = $this.ColumnName
            comparator = $this.Comparator
        }
        if ($this.RawValue) {
            $returnObject.Add('rawValue',$this.RawValue)
        }
        if ($this.ColumnValue) {
            $returnObject.Add('content',"$($this.ColumnValue)")
        }
        return [pscustomobject]$returnObject
    }
}
<#
.SYNOPSIS
    Initializes a new instance of the SortColumn class.
.DESCRIPTION
    Initializes a new instance of the SortColumn class with the provided input. This class only have 1 contructor and that contructor looks like this:

    - [SortColumn]::New(String,String)

    Available methods:
    - ToPSCustomObject (Used by private functions)
.EXAMPLE
    $SortColumn = [SortColumn]::New($Name,$Order)
.EXAMPLE
    $SortColumn.ConvertToPSCustomObject()
#>
Class SortColumn {
    [String]$Name
    [ValidateSet('Ascending','Descending')]
    [String]$Order
    SortColumn ($Name,$Order) {
        $this.Name = $Name
        $this.Order = $Order
    }
    [PSCustomObject] ToPSCustomObject () {
        return [PSCustomObject]@{
            content = $this.Name
            order = $this.Order
        }
    }
}
function Convert-EasitGODatasourceResponse {
    <#
    .SYNOPSIS
        Converts datasources in a GetDatasources JSON response to PSCustomObjects.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each datasource in a GetDatasources JSON response to a PSCustomObject.
    .EXAMPLE
        $response = Invoke-EasitGOWebRequest @baseParams
        Convert-EasitGODatasourceResponse -Response $reponse
    .PARAMETER Response
        Response object to convert
    .PARAMETER ThrottleLimit
        Specifies the number of script blocks that run in parallel. Input objects are blocked until the running script block count falls below the ThrottleLimit.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter()]
        [int]$ThrottleLimit = 5
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($Response.datasource.Count -eq 0) {
            Write-Warning "Response does not contain any datasources"
        }
        $Response.datasource.GetEnumerator() | ForEach-Object -Parallel {
            try {
                return [PSCustomObject]$_
            } catch {
                throw $_
            }
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Convert-GetItemsResponse {
    <#
    .SYNOPSIS
        Converts items in a GetItems JSON response to PSCustomObjects.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each item in a GetItems JSON response to a PSCustomObject.
    .EXAMPLE
        $response = Invoke-EasitGOWebRequest -url $url -api $api -body $body
        Convert-GetItemsResponse -Response $reponse
    .PARAMETER Response
        Response object to convert
    .PARAMETER ThrottleLimit
        Specifies the number of script blocks that run in parallel. Input objects are blocked until the running script block count falls below the ThrottleLimit.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter()]
        [int]$ThrottleLimit = 5
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($Response.totalNumberOfItems -lt 1) {
            Write-Warning "View did not return any Easit GO objects"
            return
        }
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            try {
                New-GetItemsReturnObject -Response $using:Response -Item $_
            } catch {
                throw $_
            }
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Convert-ToEasitGOJson {
    <#
    .SYNOPSIS
        Converts an object to a JSON-formatted string.
    .DESCRIPTION
        **Convert-ToEasitGOJson** acts as a wrapper for *ConvertTo-Json* to make it easier to convert objects to a JSON-formatted, with "Easit GO flavour" string.
    .EXAMPLE
        $ConvertToJsonParameters = @{
            Depth = 4
            EscapeHandling = 'EscapeNonAscii'
            WarningAction = 'SilentlyContinue'
        }
        Convert-ToEasitGOJson -InputObject $object -Parameters $ConvertToJsonParameters
    .PARAMETER InputObject
        Object to convert to JSON string.
    .PARAMETER Parameters
        Hashtable of parameters for ConvertTo-Json.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject,
        [Parameter()]
        [System.Collections.Hashtable]$Parameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($null -eq $Parameters) {
            try {
                ConvertTo-Json -InputObject $InputObject
            } catch {
                throw $_
            }
        } else {
            try {
                ConvertTo-Json -InputObject $InputObject @Parameters
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
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
function Get-EasitGOCredentialObject {
    <#
    .SYNOPSIS
        Creates a PSCredential object.
    .DESCRIPTION
        **Get-EasitGOCredentialObject** creates a credential object that can be used when sending requests to Easit GO WebAPI.
    .EXAMPLE
        Get-EasitGOCredentialObject -Apikey $Apikey

        UserName                     Password
        --------                     --------
                 System.Security.SecureString
    .PARAMETER Apikey
        APIkey used for authenticating to Easit GO WebAPI.
    .OUTPUTS
        [PSCredential](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscredential)
    #>
    [OutputType('PSCredential')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Apikey
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            [securestring]$secString = ConvertTo-SecureString $Apikey -AsPlainText -Force
        } catch {
            throw $_
        }
        try {
            New-Object System.Management.Automation.PSCredential ($Apikey, $secString)
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Invoke-EasitGOWebRequest {
    <#
    .SYNOPSIS
        Sends an HTTP or HTTPS request to the Easit GO WebAPI.
    .DESCRIPTION
        **Invoke-EasitGOWebRequest** acts as a wrapper for *Invoke-RestMethod* to send a HTTP and HTTPS request to Easit GO WebAPI.

        When Easit GO WebAPI returns a JSON-string, *Invoke-RestMethod* converts, or deserializes, the content into PSCustomObject objects.
    .EXAMPLE
        Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
    .EXAMPLE
        $InvokeRestMethodParameters = @{
            TimeoutSec = 60
            SkipCertificateCheck = $true
        }
        Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
    .PARAMETER BaseParameters
        Set of "base parameters" needed for sending a request to Easit GO WebAPI.
        Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER CustomParameters
        Set of additional parameters for Invoke-RestMethod.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BaseParameters,
        [Parameter()]
        [hashtable]$CustomParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ($null -eq $CustomParameters) {
            try {
                Invoke-RestMethod @BaseParameters
            } catch {
                throw $_
            }
        }
        if ($null -ne $CustomParameters ) {
            try {
                Invoke-RestMethod @BaseParameters @CustomParameters
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-GetEasitGODatasourceRequestBody {
    <#
    .SYNOPSIS
        Creates a JSON-formatted string.
    .DESCRIPTION
        Creates a JSON-formatted string that can be used for making a GET request for data sources from Easit GO.
    .EXAMPLE
        New-GetEasitGODatasourceRequestBody -ModuleId 1002
    .EXAMPLE
        New-GetEasitGODatasourceRequestBody -ModuleId 1002 -ParentRawValue '5:1'
    .PARAMETER ModuleId
        Specifies the module id to get data sources from.
    .PARAMETER ParentRawValue
        Specifies the id of a data sources (or entry in a data source tree) to get data sources from.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$ModuleId,
        [Parameter()]
        [string]$ParentRawValue,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $bodyObject = @{}
        try {
            $bodyObject.Add('moduleId',$ModuleId)
        } catch {
            throw $_
        }
        if ($ParentRawValue) {
            try {
                $bodyObject.Add('parentRawValue',$ParentRawValue)
            } catch {
                throw $_
            }
        }
        if ($null -eq $ConvertToJsonParameters) {
            $ConvertToJsonParameters = @{
                Depth = 4
                EscapeHandling = 'EscapeNonAscii'
                WarningAction = 'SilentlyContinue'
            }
        }
        try {
            Convert-ToEasitGOJson -InputObject $bodyObject -Parameters $ConvertToJsonParameters
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-GetEasitGOItemsRequestBody {
    <#
    .SYNOPSIS
        Creates a JSON-formatted string.
    .DESCRIPTION
        **New-GetEasitGOItemsRequestBody** creates a JSON-formatted string from the provided input to use as body for a request sent to Easit GO WebAPI.
    .EXAMPLE
        $newGetEasitGOItemsRequestBodyParams = @{
            ImportViewIdentifier = 'example'
            Page = 2
            PageSize = 50
        }
        New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        {
            "pageSize": 50,
            "page": 2,
            "itemViewIdentifier": "example"
        }
    .EXAMPLE
        $newGetEasitGOItemsRequestBodyParams = @{
            ImportViewIdentifier = 'example'
            Page = 3
            PageSize = 100
            ColumnFilter = $columnFilters
        }
        New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        {
            "pageSize": 100,
            "ColumnFilter": [
                {
                    "comparator": "LIKE",
                    "content": "b",
                    "columnName": "Beskrivning"
                },
                {
                    "comparator": "IN",
                    "rawValue": "81:1",
                    "columnName": "Status"
                }
            ],
            "page": 3,
            "itemViewIdentifier": "example"
        }
    .PARAMETER ImportViewIdentifier
        View to get objects from.
    .PARAMETER SortColumn
        Field / Column and order (Ascending / Descending) to sort objects by.
    .PARAMETER Page
        Used to get objects from a specific page in view.
    .PARAMETER PageSize
        How many objects each page in view should return.
    .PARAMETER ColumnFilter
        Field / Column to filter objects by.
    .PARAMETER IdFilter
        Database id for item to get.
    .PARAMETER FreeTextFilter
        Filter view with a search string.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json.
    .OUTPUTS
        [String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('itemViewIdentifier')]
        [string]$ImportViewIdentifier,
        [Parameter()]
        [SortColumn]$SortColumn,
        [Parameter()]
        [int]$Page,
        [Parameter()]
        [int]$PageSize,
        [Parameter()]
        [ColumnFilter[]]$ColumnFilter,
        [Parameter()]
        [string]$IdFilter,
        [Parameter()]
        [string]$FreeTextFilter,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $bodyObject = @{}
        if ($ImportViewIdentifier) {
            try {
                $bodyObject.Add('itemViewIdentifier',$ImportViewIdentifier)
            } catch {
                throw $_
            }
        }
        if ($SortColumn) {
            try {
                $bodyObject.Add('sortColumn',($SortColumn.ToPSCustomObject()))
            } catch {
                throw $_
            }
        }
        if ($Page -gt 0) {
            try {
                $bodyObject.Add('page',$Page)
            } catch {
                throw $_
            }
        }
        if ($PageSize -gt 0) {
            try {
                $bodyObject.Add('pageSize',$PageSize)
            } catch {
                throw $_
            }
        }
        if ($ColumnFilter.Count -gt 0) {
            try {
                $ColumnFilterArray = [System.Collections.Generic.List[Object]]::new()
            } catch {
                throw $_
            }
            foreach ($cf in $ColumnFilter) {
                try {
                    $ColumnFilterArray.Add(($cf.ToPSCustomObject()))
                } catch {
                    throw $_
                }
            }
            try {
                $bodyObject.Add('columnFilter',$ColumnFilterArray)
            } catch {
                throw $_
            }
        }
        if ($IdFilter) {
            try {
                $bodyObject.Add('idFilter',$IdFilter)
            } catch {
                throw $_
            }
        }
        if ($FreeTextFilter) {
            try {
                $bodyObject.Add('freeTextFilter',$FreeTextFilter)
            } catch {
                throw $_
            }
        }
        if ($null -eq $ConvertToJsonParameters) {
            $ConvertToJsonParameters = @{
                Depth = 4
                EscapeHandling = 'EscapeNonAscii'
                WarningAction = 'SilentlyContinue'
            }
        }
        try {
            Convert-ToEasitGOJson -InputObject $bodyObject -Parameters $ConvertToJsonParameters
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-GetItemsReturnObject {
    <#
    .SYNOPSIS
        Creates an base PSCustomObject returned by *Convert-GetItemsResponse*.
    .DESCRIPTION
        **New-GetItemsReturnObject** add a property named *viewDetails* with details such as RequestedPage, TotalNumberOfPages and TotalNumberOfItems to an item from a reponse object and returns it.
    .EXAMPLE
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            try {
                New-GetItemsReturnObject -Response $using:Response -Item $_
            } catch {
                throw $_
            }
        }
    .PARAMETER Response
        Response to be used as basis for a new object.
    .PARAMETER Item
        Item in response to be converted / updated.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter(Mandatory)]
        [PSCustomObject]$Item
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $viewDetails = [PSCustomObject]@{
                RequestedPage = $Response.RequestedPage
                Page = $Response.page
                TotalNumberOfPages = $Response.totalNumberOfPages
                TotalNumberOfItems = $Response.totalNumberOfItems
            }
        } catch {
            throw $_
        }
        try {
            $Item | Add-Member -MemberType NoteProperty -Name "ViewDetails" -Value $viewDetails
        } catch {
            throw $_
        }
        return $Item
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-PostEasitGOItemAttachmentObject {
    <#
    .SYNOPSIS
        Creates a PropertyObject (PSCustomObject) from a property name and value.
    .DESCRIPTION
        **New-PostEasitGOItemAttachmentObject** creates a AttachmentObject (PSCustomObject) that should be added to the attachments array for a itemToImport item.
    .EXAMPLE
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            foreach ($attachment in $property.Value) {
                try {
                    $returnObject.attachment.Add((New-PostEasitGOItemAttachmentObject -InputObject $attachment))
                } catch {
                    throw $_
                }
            }
        }
    .PARAMETER InputObject
        Object with name and value to be used for new PSCustomObject.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrEmpty($InputObject.value) -and [string]::IsNullOrEmpty($InputObject.name)) {
            Write-Warning "Name and value for attachment is null, skipping.."
            return
        }
        try {
            [PSCustomObject]@{
                value = $InputObject.Value
                name = $InputObject.Name
                contentId = ((New-Guid).Guid).Replace('-','')
            }
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-PostEasitGOItemPropertyObject {
    <#
    .SYNOPSIS
        Creates a PropertyObject (PSCustomObject) from a property name and value.
    .DESCRIPTION
        **New-PostEasitGOItemPropertyObject** creates a PropertyObject (PSCustomObject) that should be added to the property array for a itemToImport item.
    .EXAMPLE
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            $returnObject.property.Add((New-PostEasitGOItemPropertyObject -InputObject $property))
        }
    .PARAMETER InputObject
        Object with name and value to be used for new PSCustomObject.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrEmpty($InputObject.value) -and [string]::IsNullOrEmpty($InputObject.name)) {
            Write-Warning "Name and value for property is null, skipping.."
            return
        }
        if ($InputObject.Value.GetType() -eq [System.Collections.Hashtable]) {
            try {
                $tempObject = @{
                    name = $InputObject.Value.name
                }
            } catch {
                throw $_
            }
            if (!($null -eq $InputObject.Value.rawValue)) {
                $tempObject.Add('rawValue',$InputObject.Value.rawValue)
            }
            if (!($null -eq $InputObject.Value.value)) {
                $tempObject.Add('content',$InputObject.Value.value)
            }
            [PSCustomObject]$tempObject
        } else {
            try {
                [PSCustomObject]@{
                    content = $InputObject.Value
                    name = $InputObject.Name
                }
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
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
function Resolve-EasitGOURL {
    <#
    .SYNOPSIS
        Resolves a URL so that is ends with '/integration-api/[endpoint]'
    .DESCRIPTION
        **Resolve-EasitGOURL** checks if the provided string ends with */integration-api/[endpoint]* and if not it adds the parts needed.
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com' -Endpoint 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/' -Endpoint 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api' -Endpoint 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/' -Endpoint 'ping'
    .EXAMPLE
        Resolve-EasitGOURL -URL 'https://test.easit.com/integration-api/ping' -Endpoint 'ping'
    .PARAMETER URL
        URL string that should be resolved.
    .PARAMETER Endpoint
        Endpoint that URL should be solved for.
    .OUTPUTS
        [System.String](https://learn.microsoft.com/en-us/dotnet/api/system.string)
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [String]$URL,
        [Parameter(Mandatory, Position=1)]
        [String]$Endpoint
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $Endpoint = $Endpoint.ToLower()
            $Endpoint = $Endpoint.Replace('/','')
        } catch {
            throw $_
        }
        if ($URL -match '/webservice/') {
            $URL = $URL.Replace('/webservice/','')
        }
        if ($URL -match '/webservice') {
            $URL = $URL.Replace('/webservice','')
        }
        if ($URL -match "/integration-api/$Endpoint") {
            return $URL
        }
        if ($URL -match '/integration-api$') {
            return "$URL" + "/$Endpoint"
        }
        if ($URL -match '/integration-api/$') {
            return "$URL" + "$Endpoint"
        }
        if ($URL -notmatch 'integration-api/?$') {
            if ($URL -match '/$') {
                return "$URL" + "integration-api/$Endpoint"
            } else {
                return "$URL" + "/integration-api/$Endpoint"
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Get-EasitGODatasource {
    <#
    .SYNOPSIS
        Get datasources from Easit GO.
    .DESCRIPTION
        With **Get-EasitGODatasource** you can get datasources for a specific module from Easit GO. If no *ParentRawValue* is provided the function returns the modules root datasources.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all datasources in the root in the module with id 1001.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
            ParentRawValue = '5:1'
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001.
    .EXAMPLE
        $getDatasourceFromEasitGO = @{
            Url = 'https://url.to.EasitGO'
            Apikey = 'myApiKey'
            ModuleId = 1001
            ParentRawValue = '5:1'
            ReturnAsSeparateObjects = $true
        }
        Get-EasitGODatasource @getDatasourceFromEasitGO

        In this example we want to get all child datasources to the data source with databaseId (or rawValue) 5:1 in the module with id 1001 and we want them returned as separate objects.
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER ModuleId
        Specifies what module to get datasources from.
    .PARAMETER ParentRawValue
        Specifies what datasource to get child datasources from. If not specified, root level datasources will be returned.
    .PARAMETER InvokeRestMethodParameters
        Set of additional parameters for Invoke-RestMethod. Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER ReturnAsSeparateObjects
        Specifies if *Get-EasitGOItem* should return each item in the view as its own PSCustomObject.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json. Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [string]$Apikey,
        [Parameter(Mandatory)]
        [int]$ModuleId,
        [Parameter()]
        [string]$ParentRawValue,
        [Parameter()]
        [Alias('irmParams')]
        [hashtable]$InvokeRestMethodParameters,
        [Parameter()]
        [Switch]$ReturnAsSeparateObjects,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Get
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOURL -URL $URL -Endpoint 'datasources'
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Credential = Get-EasitGOCredentialObject -Apikey $Apikey
        } catch {
            throw $_
        }
        try {
            $newGetEasitGODatasourceRequestBodyParams = @{
                moduleId = $ModuleId
                ConvertToJsonParameters = $ConvertToJsonParameters
            }
        } catch {
            throw $_
        }
        if ([string]::IsNullOrEmpty($ParentRawValue)) {
            Write-Verbose "No parent raw value provided"
        } else {
            try {
                $newGetEasitGODatasourceRequestBodyParams.Add('parentRawValue',$ParentRawValue)
            } catch {
                throw $_
            }
        }
        try {
            $baseRMParams.Body = New-GetEasitGODatasourceRequestBody @newGetEasitGODatasourceRequestBodyParams
        } catch {
            throw $_
        }
        if ($null -eq $InvokeRestMethodParameters) {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
            } catch {
                throw $_
            }
        } else {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
        if ($ReturnAsSeparateObjects) {
            try {
                Convert-EasitGODatasourceResponse -Response $response
            } catch {
                throw $_
            }
        } else {
            return $response
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Get-EasitGOItem {
    <#
    .SYNOPSIS
        Get data from Easit GO.
    .DESCRIPTION
        Sends an get request to the Easit GO WebAPI and returns the result of the request.
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            Page = 2
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            IdFilter = '4659:3'
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
            PageSize = 500
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
        $columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
        $sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            ColumnFilter = $columnFilters
            SortColumn = $sortColumn
        }
        Get-EasitGOItem @getEasitGOItemParams
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
        }
        $easitObjects = Get-EasitGOItem @getEasitGOItemParams
        foreach ($easitObject in $easitObjects.items.item.GetEnumerator()) {
            Write-Host "Got object with database id $($easitGOObject.id)"
            Write-Host "The object has the following properties and values"
            foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
            }
        }
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            GetAllPages = $true
        }
        $pages = Get-EasitGOItem @getEasitGOItemParams
        foreach ($page in $pages) {
            foreach ($easitObject in $page.items.item.GetEnumerator()) {
                Write-Host "Got object with database id $($easitGOObject.id)"
                Write-Host "The object has the following properties and values"
                foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                    Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
                }
            }
        }
    .EXAMPLE
        $getEasitGOItemParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportViewIdentifier = 'myImportViewIdentifier'
            GetAllPages = $true
            ReturnAsSeparateObjects = $true
        }
        $easitObjects = Get-EasitGOItem @getEasitGOItemParams
        foreach ($easitObject in $easitObjects.GetEnumerator()) {
            Write-Host "Got object with database id $($easitGOObject.id)"
            Write-Host "The object has the following properties and values"
            foreach ($propertyObject in $easitGOObject.property.GetEnumerator()) {
                Write-Host "$($propertyObject.name) = $($propertyObject.content) (RawValue: $($propertyObject.rawValue))"
            }
        }
    .PARAMETER Url
        URL to Easit GO.
    .PARAMETER Apikey
        Apikey used for authenticating against Easit GO.
    .PARAMETER ImportViewIdentifier
        View to get data from.
    .PARAMETER SortColumn
        Used to sort data by a field / property and order (ascending / descending).
    .PARAMETER Page
        Specifies what page in the view to get data from.
    .PARAMETER PageSize
        Specifies number of items each page returns.
    .PARAMETER ColumnFilter
        Used to filter data.
    .PARAMETER IdFilter
        Database id for item to get.
    .PARAMETER FreeTextFilter
        Used to search a view with a text string.
    .PARAMETER InvokeRestMethodParameters
        Set of additional parameters for Invoke-RestMethod. Base parameters sent to Invoke-RestMethod is 'Uri','ContentType', 'Method', 'Body', 'Authentication' and 'Credential'.
    .PARAMETER ReturnAsSeparateObjects
        Specifies if *Get-EasitGOItem* should return each item in the view as its own PSCustomObject.
    .PARAMETER ConvertToJsonParameters
        Set of additional parameters for ConvertTo-Json. Base parameters sent to ConvertTo-Json is 'Depth = 4', 'EscapeHandling = 'EscapeNonAscii'', 'WarningAction = 'SilentlyContinue''.
    .PARAMETER GetAllPages
        Specifies if the function should try to get all pages from a view.
    #>
    [OutputType('PSCustomObject')]
    [Alias('Get-GOItems')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url,
        [Parameter(Mandatory)]
        [Alias('api','key')]
        [string]$Apikey,
        [Parameter(Mandatory)]
        [Alias("view")]
        [string]$ImportViewIdentifier,
        [Parameter()]
        [SortColumn]$SortColumn,
        [Parameter()]
        [Alias('viewPageNumber')]
        [int]$Page,
        [Parameter()]
        [int]$PageSize,
        [Parameter()]
        [ColumnFilter[]]$ColumnFilter,
        [Parameter()]
        [string]$IdFilter,
        [Parameter()]
        [string]$FreeTextFilter,
        [Parameter()]
        [Alias('irmParams')]
        [System.Collections.Hashtable]$InvokeRestMethodParameters,
        [Parameter()]
        [Switch]$GetAllPages,
        [Parameter()]
        [Switch]$ReturnAsSeparateObjects,
        [Parameter()]
        [System.Collections.Hashtable]$ConvertToJsonParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Get
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
        try {
            $newGetEasitGOItemsRequestBodyParams = @{
                ImportViewIdentifier = $ImportViewIdentifier
                Page = $Page
                PageSize = $PageSize
                SortColumn = $SortColumn
                ColumnFilter = $ColumnFilter
                FreeTextFilter = $FreeTextFilter
                IdFilter = $IdFilter
                ConvertToJsonParameters = $ConvertToJsonParameters
            }
        } catch {
            throw $_
        }
        if ($GetAllPages) {
            try {
                $newGetEasitGOItemsRequestBodyParams.Page = 1
                $lastPage = 1000
            } catch {
                throw $_
            }
        } else {
            try {
                $lastPage = $Page
            } catch {
                throw $_
            }
        }
        try {
            $baseRMParams.Body = New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
        } catch {
            throw $_
        }
        if ($null -eq $InvokeRestMethodParameters) {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
            } catch {
                throw $_
            }
        } else {
            try {
                $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
            } catch {
                throw $_
            }
        }
        if ($ReturnAsSeparateObjects) {
            try {
                Convert-GetItemsResponse -Response $response
            } catch {
                throw $_
            }
        } else {
            Write-Output $response
        }
        $currentPage = $response.requestedPage
        $lastPage = $response.totalNumberOfPages
        if ($GetAllPages) {
            $currentPage++
            do {
                $response = $null
                try {
                    $newGetEasitGOItemsRequestBodyParams.Page = $currentPage
                } catch {
                    throw $_
                }
                try {
                    $baseRMParams.Body = New-GetEasitGOItemsRequestBody @newGetEasitGOItemsRequestBodyParams
                } catch {
                    throw $_
                }
                if ($null -eq $InvokeRestMethodParameters) {
                    try {
                        $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams
                    } catch {
                        throw $_
                    }
                } else {
                    try {
                        $response = Invoke-EasitGOWebRequest -BaseParameters $baseRMParams -CustomParameters $InvokeRestMethodParameters
                    } catch {
                        throw $_
                    }
                }
                if ($ReturnAsSeparateObjects) {
                    try {
                        Convert-GetItemsResponse -Response $response
                    } catch {
                        throw $_
                    }
                } else {
                    Write-Output $response
                }
                $currentPage++
            } while ($currentPage -le $lastPage)
        }
    }
    end {
        [System.GC]::Collect()
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-ColumnFilter {
    <#
    .SYNOPSIS
        Creates a new instance of the ColumnFilter class.
    .DESCRIPTION
        **New-ColumnFilter** acts as a wrapper function for the ColumnFilter class included in the module Easit.GO.Webservice.
        With the provided input it returns an instance of the ColumnFilter class.
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Description' -Comparator 'LIKE' -ColumnValue 'A description'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '81:1' -Comparator 'IN'
        } catch {
            throw $_
        }
    .EXAMPLE
        $columnFilters = @()
        try {
            $columnFilters += New-ColumnFilter -ColumnName 'Status' -RawValue '73:1' -Comparator 'IN' -ColumnValue 'Registrered'
        } catch {
            throw $_
        }
    .PARAMETER ColumnName
        Name of the column / field to filter against.
    .PARAMETER RawValue
        The raw value (database id) for the value in the column / field.
    .PARAMETER Comparator
        What comparator to use and filter with.
    .PARAMETER ColumnValue
        String value for the column / field.
    .OUTPUTS
        [ColumnFilter](https://docs.easitgo.com/techspace/psmodules/)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$ColumnName,
        [Parameter()]
        [String]$RawValue,
        [Parameter(Mandatory)]
        [ValidateSet('EQUALS','NOT_EQUALS','IN','NOT_IN','GREATER_THAN','GREATER_THAN_OR_EQUALS','LESS_THAN','LESS_THAN_OR_EQUALS','LIKE','NOT_LIKE')]
        [String]$Comparator,
        [Parameter()]
        [String]$ColumnValue
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrWhiteSpace($RawValue) -and !([string]::IsNullOrWhiteSpace($ColumnValue))) {
            try {
                [ColumnFilter]::New($ColumnName,$null,$Comparator,$ColumnValue)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($ColumnValue) -and !([string]::IsNullOrWhiteSpace($RawValue))) {
            try {
                [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$null)
            } catch {
                throw $_
            }
        } elseif ([string]::IsNullOrWhiteSpace($RawValue) -and [string]::IsNullOrWhiteSpace($ColumnValue)) {
            if ([string]::IsNullOrWhiteSpace($ColumnValue)) {
                throw "ColumnValue is null or whitespace"
            }
            if ([string]::IsNullOrWhiteSpace($RawValue)) {
                throw "RawValue is null or whitespace"
            }
        } else {
            try {
                [ColumnFilter]::New($ColumnName,$RawValue,$Comparator,$ColumnValue)
            } catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-EasitGOItemToImport {
    <#
    .SYNOPSIS
        Creates a PSCustomObject that can be added to itemToImport.
    .DESCRIPTION
        **New-EasitGOItemToImport** creates a new PSCustomObject with properties and arrays in such a way that the result of *ConvertTo-Json -Item $myItem* is formatted as needed by the Easit GO WebAPI.

        The new PSCustomObject will have the following properties:
        - id (generated number unique for the item/object)
        - uid (generated value unique for the item/object)
        - property (array)
        - attachment (array)

        Each property returned by *$Item.psobject.properties.GetEnumerator()* will be added as a PSCustomObject to the property array.
        If the property returned by *$Item.psobject.properties.GetEnumerator()* has a name equal to *attachments* the property will be handled as an array of objects.
    .EXAMPLE
        $attachments = @(@{name='attachmentName';value='base64string'},@{name='attachmentName2';value='base64string2'})
        $myItem = [PSCustomObject]@{property1='propertyValue1';property2='propertyValue2';attachments=$attachments}
        New-EasitGOItemToImport -Item $myItem -ID 1
        id uid                              property                                                                               attachment
        -- ---                              --------                                                                               ----------
        1  0a65061df0814d6394736303587783f7 {@{content=propertyValue1; name=property1}, @{content=propertyValue2; name=property2}} {}
    .PARAMETER Item
        Item / Object to be added to *itemToImport* array.
    .PARAMETER ID
        ID to be set as id for item / object.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$Item,
        [Parameter(Mandatory)]
        [int]$ID
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
            $returnObject | Add-Member -MemberType NoteProperty -Name "id" -Value $ID
            $returnObject | Add-Member -MemberType NoteProperty -Name "uid" -Value ((New-Guid).Guid).Replace('-','')
            $returnObject | Add-Member -MemberType NoteProperty -Name "property" -Value ([System.Collections.Generic.List[Object]]::new())
            $returnObject | Add-Member -MemberType NoteProperty -Name "attachment" -Value ([System.Collections.Generic.List[Object]]::new())
        } catch {
            throw $_
        }
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            if ($property.Name -eq 'attachments') {
                foreach ($attachment in $property.Value) {
                    try {
                        $returnObject.attachment.Add((New-PostEasitGOItemAttachmentObject -InputObject $attachment))
                    } catch {
                        throw $_
                    }
                }
            } else {
                if ($property.Value.GetType() -eq [System.Object[]]) {
                    foreach ($value in $property.Value.GetEnumerator()) {
                        try {
                            $returnObject.property.Add((
                                New-PostEasitGOItemPropertyObject -InputObject ([PSCustomObject]@{
                                    Name = $property.Name
                                    Value = $value
                                })
                            ))
                        } catch {
                            throw $_
                        }
                    }
                } else {
                    try {
                        $returnObject.property.Add((New-PostEasitGOItemPropertyObject -InputObject $property))
                    } catch {
                        throw $_
                    }
                }
            }
        }
        return $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function New-SortColumn {
    <#
    .SYNOPSIS
        Creates a new instance of the SortColumn class.
    .DESCRIPTION
        **New-SortColumn** acts as a wrapper function for the SortColumn class included in the module Easit.GO.Webservice.
        With the provided input it returns an instance of the SortColumn class.
    .EXAMPLE
        $sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
    .PARAMETER Name
        Name of the column / field to sort by.
    .PARAMETER Order
        Specifies if sort order should be descending or ascending.
    .OUTPUTS
        [SortColumn](https://docs.easitgo.com/techspace/psmodules/)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [ValidateSet('Ascending','Descending')]
        [String]$Order
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            [SortColumn]::New($Name,$Order)
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
function Send-ToEasitGO {
    <#
    .SYNOPSIS
        Send one or more objects to Easit GO WebAPI.
    .DESCRIPTION
        Create or update any object or objects in Easit GO. This function can be used with any importhandler, module and object in Easit GO.
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
            SendInBatchesOf = 75
        }
        $csvData = Import-Csv -Path 'C:\Path\To\My\csvFile.csv' -Delimiter ';' -Encoding 'utf8'
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
        Import-Csv -Path 'C:\Path\To\My\csvFile.csv' -Delimiter ';' -Encoding 'utf8' | Send-ToEasitGO @sendToEasitParams
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        $customItem = @{
            prop1=@('value1','value4','value5')
            prop2="value2"
            prop3="value3"
        }
        Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
    .EXAMPLE
        $sendToEasitParams = @{
            Url = 'https://go.easit.com'
            Apikey = 'myApikey'
            ImportHandlerIdentifier = 'myImportHandler'
        }
        $customItem = @{
            prop1=@{
                name = 'propertyNameUsedAsnameInJSON'
                value = 'propertyValue'
                rawValue = 'propertyRawValue'
            }
            prop2="value2"
            prop3="value3"
        }
        Send-ToEasitGO @sendToEasitParams -CustomItem $customItem
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
        [Alias('CustomProperties')]
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
function Test-EasitGOConnection {
    <#
    .SYNOPSIS
        Used to ping any Easit GO application using REST.
    .DESCRIPTION
        **Test-EasitGOConnection** can be use to check if a Easit GO application is up and running, supports REST and "reachable".
    .EXAMPLE
        Test-EasitGOConnection -URL 'https://test.easit.com'
    .PARAMETER URL
        URL to Easit GO application.
    .PARAMETER InvokeRestMethodParameters
        Additional parameters to be used by *Invoke-RestMethod*. Used to customize how *Invoke-RestMethod* behaves.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0)]
        [String]$URL,
        [Parameter()]
        [Alias('irmParams')]
        [hashtable]$InvokeRestMethodParameters
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        try {
            $baseRMParams = Get-BaseRestMethodParameter -Ping
        } catch {
            throw $_
        }
        try {
            $baseRMParams.Uri = Resolve-EasitGOURL -URL $URL -Endpoint 'ping'
        } catch {
            throw $_
        }
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
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}
