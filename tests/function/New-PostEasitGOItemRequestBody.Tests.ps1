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
    try {
        $testObject = Import-Csv -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'contacts_1.csv') -Delimiter ';'
    } catch {
        throw $_
    }
    function New-EasitGOItemToImport {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [Object]$Item,
            [Parameter(Mandatory)]
            [int]$ID
        )
        
        begin {}
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
                try {
                    $returnObject.property.Add(([PSCustomObject]@{$property.Name=$property.value}))
                } catch {
                    throw $_
                }
            }
            return $returnObject
        }
        end {}
    }
    $validInput = @{
        ImportHandlerIdentifier = 'importhandler'
        IDStart = 1
        Items = $testObject
    }
    $invalidInput = @{
        ImportHandlerIdentifier = 'importhandler'
        IDStart = 1
        Items = $null
    }
    function Convert-ToEasitGOJson {
        param (
            [Parameter(Mandatory)]
            [PSCustomObject]$InputObject,
            [Parameter()]
            [System.Collections.Hashtable]$Parameters
        )
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'importItemsRequest.json') -Raw
    }
}
Describe "New-PostEasitGOItemRequestBody" -Tag 'function','private' {
    It 'should have a parameter named ImportHandlerIdentifier that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ImportHandlerIdentifier -Type 'string'
    }
    It 'should have a parameter named Items that accepts a Object array' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Items -Type 'Object[]'
    }
    It 'should have a parameter named IDStart that accepts an integer' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter IDStart -Type 'int'
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
    It 'should not throw with valid input' {
        {New-PostEasitGOItemRequestBody @validInput} | Should -Not -Throw
    }
    It 'should throw with invalid input' {
        {New-PostEasitGOItemRequestBody @invalidInput} | Should -Throw
    }
    It 'should return a string' {
        $output = New-PostEasitGOItemRequestBody @validInput
        $output | Should -BeOfType 'System.String'
    }
}