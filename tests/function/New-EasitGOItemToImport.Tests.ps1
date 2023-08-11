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
    function New-PostEasitGOItemPropertyObject {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory)]
            [Object]$InputObject
        )
        begin {}
        process {
            if ([string]::IsNullOrEmpty($InputObject.value) -and [string]::IsNullOrEmpty($InputObject.name)) {
                Write-Warning "Name and value for property is null, skipping.."
                return
            }
            try {
                [PSCustomObject]@{
                    content = $InputObject.Value
                    name = $InputObject.Name
                }
            } catch {
                throw $_
            }
        }
        end {}
    }
    $validInput = @{
        ID = 1
        Item = $testObject
    }
    $invalidInput = @{
        IDStart = 1
        Items = $null
    }
    try {
        $output = New-EasitGOItemToImport @validInput
    } catch {
        throw $_
    }
}
Describe "New-EasitGOItemToImport" -Tag 'function','private' {
    It 'should have a parameter named Item that accepts an object' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Item -Type 'Object'
    }
    It 'should have a parameter named ID that accepts an integer' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ID -Type 'int'
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
        {New-EasitGOItemToImport @validInput} | Should -Not -Throw
    }
    It 'should throw with invalid input' {
        {New-EasitGOItemToImport @invalidInput} | Should -Throw
    }
    It 'should return a PSCustomObject' {
        $output | Should -BeOfType 'PSCustomObject'
    }
    It 'returned object should have an ID of 1' {
        $output.id | Should -BeExactly 1
    }
    It 'returned object should have a uid' {
        $output.uid | Should -Not -BeNullOrEmpty
    }
    It 'returned objects property count should be 6' {
        $output.property.Count | Should -BeExactly 6
    }
}