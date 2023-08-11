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
    function Invoke-RestMethod {
        [CmdletBinding()]
        param (
            $parameter1,
            $parameter2,
            $parameter3,
            $parameter4
        )
        begin {}
        process {
            Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'importItemsResponse.json') -Raw | ConvertFrom-Json
        }
        end {}
    }
    $bP = @{
        parameter1 = 'value1'
        parameter2 = 'value2'
    }
    $cP = @{
        parameter3 = 'value3'
        parameter4 = 'value4'
    }
}
Describe "Invoke-EasitGOWebRequest" -Tag 'function','private' {
    It 'should have a parameter named BaseParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter BaseParameters -Type 'hashtable'
    }
    It 'should have a parameter named CustomParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter CustomParameters -Type 'hashtable'
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
    It 'should not throw with only base parameters' {
        {Invoke-EasitGOWebRequest -BaseParameters $bP} | Should -Not -Throw
    }
    It 'should not throw with base and custom parameters' {
        {Invoke-EasitGOWebRequest -BaseParameters $bP -CustomParameters $cP} | Should -Not -Throw
    }
    It 'should return a PSCustomObject' {
        (Invoke-EasitGOWebRequest -BaseParameters $bP -CustomParameters $cP) | Should -BeOfType PSCustomObject
    }
    It 'should throw due to invalid parameters' {
        {Invoke-EasitGOWebRequest -BaseParameters @{parameter5='value5'}} | Should -Throw
    }
}