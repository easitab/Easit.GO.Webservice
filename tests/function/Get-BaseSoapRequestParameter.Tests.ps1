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
Describe "Get-BaseSoapRequestParameter" -Tag 'function','private' {
    It 'should have a parameter named NoUri that is a switch.' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter NoUri -Type [Switch]
    }
    It 'should have a parameter named ContentType that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ContentType -Type [Switch]
    }
    It 'should have a parameter named ErrorHandling that is a switch' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter ErrorHandling -Type [Switch]
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
    It 'should not throw with no parameters provided' {
        {Get-BaseSoapRequestParameter} | Should -Not -Throw
    }
    It 'should not throw with parameter "NoUri" provided' {
        {Get-BaseSoapRequestParameter -NoUri} | Should -Not -Throw
    }
    It 'should only return a ordered dictionary (ordered hashtable) with a key named "Uri"' {
        $object = Get-BaseSoapRequestParameter -NoUri
        {$object.Add('Uri','aUri')} | Should -Not -Throw
    }
    It 'should not throw with parameter "ContentType" provided' {
        {Get-BaseSoapRequestParameter -ContentType} | Should -Not -Throw
    }
    It 'should return a ordered dictionary (ordered hashtable) with a key named "ContentType"' {
        $object = Get-BaseSoapRequestParameter -ContentType -NoUri
        {$object.Add('Uri','aUri')} | Should -Not -Throw
        {$object.Add('ErrorAction','aUri')} | Should -Not -Throw
        {$object.Add('ContentType','aUri')} | Should -Throw
    }
    It 'should not throw with parameter "ErrorHandling" provided' {
        {Get-BaseSoapRequestParameter -ErrorHandling} | Should -Not -Throw
    }
    It 'should return a ordered dictionary (ordered hashtable) with a key named "ErrorAction"' {
        $object = Get-BaseSoapRequestParameter -ErrorHandling -NoUri
        {$object.Add('Uri','aUri')} | Should -Not -Throw
        {$object.Add('ErrorAction','aUri')} | Should -Throw
        {$object.Add('ContentType','aUri')} | Should -Not -Throw
    }
    It 'should not throw with parameter "ErrorHandling" and "ContentType" provided' {
        {Get-BaseSoapRequestParameter -ErrorHandling -ContentType} | Should -Not -Throw
    }
    It 'should return a ordered dictionary (ordered hashtable) with a key named "Uri", "ContentType", "ErrorAction"' {
        $object = Get-BaseSoapRequestParameter -ErrorHandling -ContentType
        {$object.Add('Uri','aUri')} | Should -Throw
        {$object.Add('ErrorAction','aUri')} | Should -Throw
        {$object.Add('ContentType','aUri')} | Should -Throw
    }
}