BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
    function Get-BaseRestMethodParameter {
        param (
            [Parameter()]
            [Switch]$Post
        )
        return [System.Collections.Hashtable]@{
            Url = 'https://url.to.EasitGO'
            Method = 'Post'
            ContentType = 'application/json'
            Authentication = 'Basic'
            Credential = $null
        }
    }
    function Resolve-EasitGOUrl {
        param (
            [Parameter()]
            [String]$URL,
            [Parameter()]
            [String]$Endpoint
        )
        return 'https://url.to.EasitGO/integration-api/datasources/'
    }
    function Get-EasitGOCredentialObject {
        param (
            [Parameter()]
            [String]$Apikey
        )
        [securestring]$secString = ConvertTo-SecureString $Apikey -AsPlainText -Force
        New-Object System.Management.Automation.PSCredential ($Apikey, $secString)
    }
    function New-EasitGOItemToImport {
        param (
            [Parameter(Mandatory)]
            [Object]$Item,
            [Parameter(Mandatory)]
            [int]$ID
        )
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
                        $attachmentObject = [PSCustomObject]@{
                            value = $InputObject.Value
                            name = $InputObject.Name
                            contentId = ((New-Guid).Guid).Replace('-','')
                        }
                        $returnObject.attachment.Add($attachmentObject)
                    } catch {
                        throw $_
                    }
                }
            } else {
                try {
                    $propObject = [PSCustomObject]@{
                        content = $property.Value
                        name = $property.Name
                    }
                    $returnObject.property.Add($propObject)
                } catch {
                    throw $_
                }
            }
        }
        return $returnObject
    }
    function New-PostEasitGOItemRequestBody {
        param (
            [Parameter()]
            [String]$ImportHandlerIdentifier,
            [Parameter()]
            [Int]$IDStart,
            [Parameter()]
            [Object[]]$Items,
            [Parameter()]
            [System.Collections.Hashtable]$ConvertToJsonParameters
        )
        $itemsToImport = [System.Collections.Generic.List[Object]]::new()
        foreach ($item in $Items) {
            try {
                $itemToAdd = New-EasitGOItemToImport -Item $item -ID $IDStart
            } catch {
                throw $_
            }
            try {
                $itemsToImport.Add($itemToAdd)
            } catch {
                throw $_
            }
            $IDStart++
        }
        [System.Collections.Hashtable]@{
            importHandlerIdentifier = $ImportHandlerIdentifier
            itemToImport = $itemsToImport
        } | ConvertTo-Json -Depth 4 -Compress -EscapeHandling EscapeNonAscii
    }
    function Invoke-EasitGOWebRequest {
        param (
            [Parameter()]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceResponse.json') -Raw | ConvertFrom-Json
    }
    $sendToEasitParams = @{
        Url = 'https://go.easit.com'
        Apikey = 'myApikey'
        ImportHandlerIdentifier = 'testHandler'
    }
}
Describe "Send-ToEasitGO" -Tag 'function','public' {
    It 'should have a parameter named Url that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Url -Mandatory -Type 'String'
    }
    It 'should have a parameter named Apikey that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Apikey -Mandatory -Type 'String'
    }
    It 'should have a parameter named ImportHandlerIdentifier that is mandatory and accepts a string.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ImportHandlerIdentifier -Mandatory -Type 'String'
    }
    It 'should have a parameter named Item that accepts an object array.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Item -Type 'Object[]'
    }
    It 'should have a parameter named CustomItem that accepts a hashtable.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter CustomItem -Type 'System.Collections.Hashtable'
    }
    It 'should have a parameter named SendInBatchesOf that accepts an integer.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter SendInBatchesOf -Type 'int'
    }
    It 'should have a parameter named IDStart that accepts an integer.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter IDStart -Type 'int'
    }
    It 'should have a parameter named InvokeRestMethodParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InvokeRestMethodParameters -Type 'System.Collections.Hashtable'
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help "$($envSettings.CommandName)" -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help "$($envSettings.CommandName)" -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help "$($envSettings.CommandName)" -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should have a HelpUri' {
        ((Get-Command "$($envSettings.CommandName)").HelpUri).Length | Should -BeGreaterThan 0
    }
    It 'all parameters should have a description' {
        $commonParameters = [System.Management.Automation.PSCmdlet]::CommonParameters
        $optionalCommonParameters = [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
        foreach ($param in (Get-Help -Name "$($envSettings.CommandName)" -Full).parameters.parameter) {
            if ($commonParameters -notcontains $param.name -and $optionalCommonParameters -notcontains $param.name) {
                ($param.description.Text).Length | Should -BeGreaterThan 0
            }
        }
    }
    It 'should not throw when sending an CustomItem' {
        {Send-ToEasitGO @sendToEasitParams -CustomItem (@{prop1="value1";prop2="value2";prop3="value3"})} | Should -Not -Throw
    }
    It 'should not throw when sending an Item' {
        $csvItems = Import-Csv -Path (Join-Path -Path "$($envSettings.TestDataDirectory)" -ChildPath 'contacts_1.csv') -Delimiter ';' -Encoding utf8
        {Send-ToEasitGO @sendToEasitParams -Item $csvItems} | Should -Not -Throw
    }
    It 'should not throw when sending an array of Items' {
        $csvItems = Import-Csv -Path (Join-Path -Path "$($envSettings.TestDataDirectory)" -ChildPath 'contacts.csv') -Delimiter ';' -Encoding utf8
        {Send-ToEasitGO @sendToEasitParams -Item $csvItems} | Should -Not -Throw
    }
}