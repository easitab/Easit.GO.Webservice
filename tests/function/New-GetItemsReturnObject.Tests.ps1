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
    $reponseObject = Get-Content (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getItemsResponse_1_items.json') -Raw | ConvertFrom-Json
}
Describe "New-GetItemsReturnObject" {
    It 'should have a parameter named Response that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Response -Mandatory -Type PSCustomObject
    }
    It 'should have a parameter named Item that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Item -Mandatory -Type PSCustomObject
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help 'New-GetItemsReturnObject' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'New-GetItemsReturnObject' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'New-GetItemsReturnObject' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should not throw' {
        {New-GetItemsReturnObject -Response $reponseObject -Item $reponseObject.items.item[0]} | Should -Not -Throw
    }
    It 'should return a PSCustomObject' {
        {New-GetItemsReturnObject -Response $reponseObject -Item $reponseObject.items.item[0]} | Should -BeOfType PSCustomObject
    }
}