BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSettings.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSettings -Path $PSCommandPath
    } catch {
        throw $_
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
    [xml]$pingResponse = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'pingResponse.xml') -Raw
}
Describe "New-PingReturnObject" -Tag 'function','private' {
    It 'should have a parameter named XML that is mandatory and accepts a XML object.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter XML -Mandatory -Type XML
    }
    It 'should return a PSCustomObject' {
        (New-PingReturnObject -XML $pingResponse).GetType() | Should -BeExactly 'PSCustomObject'
    }
    It 'should throw when input is null' {
        {New-PingReturnObject -XML $pingResponse2} | Should -Throw
    }
}