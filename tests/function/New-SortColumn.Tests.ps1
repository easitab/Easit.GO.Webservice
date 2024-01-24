BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    foreach ($class in Get-ChildItem -Path (Join-Path -Path $envSettings.SourceDirectory -ChildPath 'classes') -Recurse -File) {
        . $class.FullName
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
}
Describe "New-SortColumn" -Tag 'function' {
    It 'should have a parameter named Property that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Property -Type [System.String]
    }
    It 'should have a parameter named Order that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Order -Type [System.String]
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
    It 'should not throw when input is valid' {
        {New-SortColumn -Property 'Status' -Order 'Ascending'} | Should -Not -Throw
    }
    It 'should throw when input is NOT valid' {
        {New-SortColumn -Property 'Status' -Order ''} | Should -Throw
    }
    It 'column value should not be null' {
        $sortColumn = New-SortColumn -Property 'Status' -Order 'Ascending'
        $sortColumn.PropertyName | Should -Not -BeNullOrEmpty
    }
    It 'name value should not be null' {
        $sortColumn = New-SortColumn -Property 'Status' -Order 'Ascending'
        $sortColumn.Order | Should -Not -BeNullOrEmpty
    }
    It 'method "ToPSCustomObject" should not throw' {
        $sortColumn = New-SortColumn -Property 'Status' -Order 'Ascending'
        {$sortColumn.ToPSCustomObject()} | Should -Not -Throw
    }
    It 'content should not be empty after method "ToPSCustomObject"' {
        $sortColumn = New-SortColumn -Property 'Status' -Order 'Ascending'
        {($sortColumn.ToPSCustomObject()).content} | Should -Not -BeNullOrEmpty
    }
    It 'order should not be empty after method "ToPSCustomObject"' {
        $sortColumn = New-SortColumn -Property 'Status' -Order 'Ascending'
        {($sortColumn.ToPSCustomObject()).order} | Should -Not -BeNullOrEmpty
    }
}