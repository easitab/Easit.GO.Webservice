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
    $reponseObject = Get-Content (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getItemsResponse_1_items_collections.json') -Raw | ConvertFrom-Json
}
Describe "New-FlatGetItemsReturnObject" -Tag 'function','private' {
    It 'should have a parameter named Response that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Response -Mandatory -Type PSCustomObject
    }
    It 'should have a parameter named Item that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Item -Mandatory -Type PSCustomObject
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
    It 'should not throw' {
        {New-FlatGetItemsReturnObject -Response $reponseObject -Item $reponseObject.items.item[0]} | Should -Not -Throw
    }
    It 'should return a PSCustomObject' {
        {New-FlatGetItemsReturnObject -Response $reponseObject -Item $reponseObject.items.item[0]} | Should -BeOfType PSCustomObject
    }
}