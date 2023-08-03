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
Describe "Get-BaseRestMethodParameters" -Tag 'function','private' {
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
        ((Get-Help 'Get-BaseRestMethodParameters' -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help 'Get-BaseRestMethodParameters' -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help 'Get-BaseRestMethodParameters' -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It '"Get-BaseRestMethodParameters" should return a Hashtable' {
        (Get-BaseRestMethodParameters -Ping) | Should -BeOfType [hashtable]
    }
    It '"Get-BaseRestMethodParameters -Ping" should return a Hashtable' {
        (Get-BaseRestMethodParameters -Ping) | Should -BeOfType [hashtable]
    }
    It '"Get-BaseRestMethodParameters -Get" should return a Hashtable' {
        (Get-BaseRestMethodParameters -Get) | Should -BeOfType [hashtable]
    }
    It '"Get-BaseRestMethodParameters -Post" should return a Hashtable' {
        (Get-BaseRestMethodParameters -Post) | Should -BeOfType [hashtable]
    }
}