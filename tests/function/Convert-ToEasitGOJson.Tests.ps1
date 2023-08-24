BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    foreach ($class in Get-ChildItem -Path (Join-Path $envSettings.SourceDirectory -ChildPath 'classes') -Recurse -File) {
        . $class.FullName
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
}
Describe "Convert-ToEasitGOJson" -Tag 'function','private' {
    It 'should have a parameter named InputObject that is mandatory and accepts an PSCustomObject.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InputObject -Mandatory -Type 'PSCustomObject'
    }
    It 'should have a parameter named Parameters that accepts an System.Collections.Hashtable.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Parameters -Type 'System.Collections.Hashtable'
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
        $inputObject = [PSCustomObject]@{prop1="value1";prop2="value2"}
        {Convert-ToEasitGOJson -InputObject $inputObject} | Should -Not -Throw
    }
}