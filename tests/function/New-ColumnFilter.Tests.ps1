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
Describe "New-ColumnFilter" -Tag 'function' {
    It 'should have a parameter named Property that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Property -Type [System.String]
    }
    It 'should have a parameter named RawValue that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter RawValue -Type [System.String]
    }
    It 'should have a parameter named Comparator that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Comparator -Type [System.String]
    }
    It 'should have a parameter named Value that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Value -Type [System.String]
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help 'New-ColumnFilter' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'New-ColumnFilter' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'New-ColumnFilter' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should not throw' {
        {New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'} | Should -Not -Throw
    }
    It 'column value should not be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilter.PropertyValue | Should -Not -BeNullOrEmpty
    }
    It 'name value should not be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilter.PropertyName | Should -Not -BeNullOrEmpty
    }
    It 'Comparator value should not be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilter.Comparator | Should -Not -BeNullOrEmpty
    }
    It 'RawValue value should be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilter.RawValue | Should -BeNullOrEmpty
    }
    It 'RawValue value should not be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open' -RawValue '35:4'
        $columnFilter.RawValue | Should -Not -BeNullOrEmpty
    }
    It 'column value value should be null' {
        $columnFilter = New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -RawValue '35:4'
        $columnFilter.PropertyValue | Should -BeNullOrEmpty
    }
}