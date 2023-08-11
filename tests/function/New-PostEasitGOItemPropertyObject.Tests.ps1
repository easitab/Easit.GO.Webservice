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
    $testObject = [PSCustomObject]@{name1='attachmentName2';name2=''}
}
Describe "New-PostEasitGOItemPropertyObject" -Tag 'function','private' {
    It 'should have a parameter named InputObject that is mandatory and accepts a object' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter InputObject -Mandatory -Type Object
    }
    It 'should have SYNOPSIS' {
        ((Get-Help "$($envSettings.CommandName)" -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'should have DESCRIPTION' {
        ((Get-Help "$($envSettings.CommandName)" -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'should have EXAMPLES' {
        ((Get-Help "$($envSettings.CommandName)" -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should not throw with valid input' {
        {New-PostEasitGOItemPropertyObject -InputObject (Get-Member -InputObject $testObject -Name 'name1')} | Should -Not -Throw
    }
    It 'should NOT return null with valid input' {
        $output = New-PostEasitGOItemPropertyObject -InputObject (Get-Member -InputObject $testObject -Name 'name1')
        $output | Should -Not -BeNullOrEmpty
    }
}