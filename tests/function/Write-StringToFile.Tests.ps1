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
    function Out-File {
        param (
            [Parameter(ValueFromPipeline)]
            [String]$String,
            [Parameter()]
            [String]$FilePath,
            [Parameter()]
            [String]$Encoding,
            [Parameter()]
            [Switch]$Force
        )
    }
}
Describe "Write-StringToFile" -Tag 'function','private' {
    It 'should have a parameter named InputString that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InputString -Type [System.String]
    }
    It 'should have a parameter named FilenamePrefix that accepts a string' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter FilenamePrefix -Type [System.String]
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
        {Write-StringToFile -InputString 'bodytowritetofile' -FilenamePrefix 'SendToEasitGO'} | Should -Not -Throw
    }
}