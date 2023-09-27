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
    $queryParams = [ordered]@{
        apikey = 'myApiKey'
        identifier = 'identifier'
    }
}
Describe "New-UriQueryString" -Tag 'function','private' {
    It 'should have a parameter named QueryParams that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter QueryParams -Mandatory -Type [System.Collections.Specialized.OrderedDictionary]
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
    It 'should not throw with valid input' {
        {New-UriQueryString -QueryParams $queryParams} | Should -Not -Throw
    }
    It 'should return expected string' {
        $returnedString = New-UriQueryString -QueryParams $queryParams
        $returnedString | Should -BeExactly 'apikey=myApiKey&identifier=identifier'
    }
}