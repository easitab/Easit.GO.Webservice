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
    $attachment = [PSCustomObject]@{name='attachmentName2';value='base64string2'}
    $invalidAttachment = [PSCustomObject]@{name='';value=''}
}
Describe "New-PostEasitGOItemAttachmentObject" -Tag 'function','private' {
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
    It 'should not throw' {
        {New-PostEasitGOItemAttachmentObject -InputObject $attachment} | Should -Not -Throw
    }
    It 'should NOT return null with valid input' {
        $output = New-PostEasitGOItemAttachmentObject -InputObject $attachment
        $output | Should -Not -BeNullOrEmpty
    }
    It 'should be return null with invalid input' {
        $output = New-PostEasitGOItemAttachmentObject -InputObject $invalidAttachment -WarningAction SilentlyContinue
        $output | Should -BeNullOrEmpty
    }
}