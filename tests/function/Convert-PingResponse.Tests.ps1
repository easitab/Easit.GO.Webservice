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
    [xml]$pingResponse = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'pingResponse.xml') -Raw
    function New-PingReturnObject {
        $returnObject = New-Object PSCustomObject
        $returnObject | Add-Member -MemberType Noteproperty -Name "Message" -Value "Pong!"
        $returnObject | Add-Member -MemberType Noteproperty -Name "Timestamp" -Value "2022-06-13T11:19:45.230Z"
        return $returnObject
    }
}
Describe "Convert-PingResponse" -Tag 'function','private' {
    It 'should have a parameter named Response that is mandatory and accepts a XML object.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter Response -Mandatory -Type XML
    }
    It 'should return a PSCustomObject' {
        (Convert-PingResponse -Response $pingResponse).GetType() | Should -BeExactly 'PSCustomObject'
    }
    It 'should throw when input is null' {
        {Convert-PingResponse -Response $pingResponse2} | Should -Throw
    }
}