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
}
Describe "New-GetEasitGOItemsRequestBody" -Tag 'function','private' {
    It 'should have a mandatory parameter named ImportViewIdentifier that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ImportViewIdentifier -Mandatory -Type 'String'
    }
    It 'should have a parameter named ColumnFilter' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ColumnFilter
    }
    It 'should have a parameter named SortColumn' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter SortColumn
    }
    It 'should have a parameter named Page' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Page -Type 'Int'
    }
    It 'should have a parameter named PageSize' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter PageSize -Type 'Int'
    }
    It 'should have a parameter named IdFilter' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter IdFilter -Type 'String'
    }
    It 'should have a parameter named FreeTextFilter' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter FreeTextFilter -Type 'String'
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help 'New-GetEasitGOItemsRequestBody' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'New-GetEasitGOItemsRequestBody' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'New-GetEasitGOItemsRequestBody' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should return a string' {
        (New-GetEasitGOItemsRequestBody -ImportViewIdentifier 'dummyView') | Should -BeOfType [System.String]
    }
    It 'should return a string with length greater or equal than 38' {
        (New-GetEasitGOItemsRequestBody -ImportViewIdentifier 'dummyView').Length | Should -BeGreaterOrEqual 38
    }
    It 'should return a string with length less or equal than 41' {
        (New-GetEasitGOItemsRequestBody -ImportViewIdentifier 'dummyView').Length | Should -BeLessOrEqual 41
    }
}