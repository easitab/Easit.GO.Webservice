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
Describe "Get-BaseRestMethodParameter" -Tag 'function','private' {
    It 'should have a parameter named Ping that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Ping -Type 'Switch'
    }
    It 'should have a parameter named Get that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Get -Type 'Switch'
    }
    It 'should have a parameter named Post that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Post -Type 'Switch'
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help 'Get-BaseRestMethodParameter' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'Get-BaseRestMethodParameter' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'Get-BaseRestMethodParameter' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It '"Get-BaseRestMethodParameter" should throw if no request type is specified' {
        {Get-BaseRestMethodParameter} | Should -Throw
    }
    It '"Get-BaseRestMethodParameter -Ping" should return a Hashtable' {
        (Get-BaseRestMethodParameter -Ping) | Should -BeOfType [hashtable]
    }
    It '"Get-BaseRestMethodParameter -Get" should return a Hashtable' {
        (Get-BaseRestMethodParameter -Get) | Should -BeOfType [hashtable]
    }
    It '"Get-BaseRestMethodParameter -Post" should return a Hashtable' {
        (Get-BaseRestMethodParameter -Post) | Should -BeOfType [hashtable]
    }
}