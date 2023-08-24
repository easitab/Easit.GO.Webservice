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
    foreach ($class in Get-ChildItem -Path (Join-Path -Path $envSettings.SourceDirectory -ChildPath 'classes') -Recurse -File) {
        . $class.FullName
    }
    foreach ($privateFunction in Get-ChildItem -Path (Join-Path -Path $envSettings.SourceDirectory -ChildPath 'private') -Recurse -File) {
        . $privateFunction.FullName
    }
    foreach ($publicFunction in Get-ChildItem -Path (Join-Path -Path $envSettings.SourceDirectory -ChildPath 'public') -Recurse -File) {
        . $publicFunction.FullName
    }
    function Invoke-EasitGOWebRequest {
        param (
            [Parameter(Mandatory)]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters
        )
        [PSCustomObject]@{
            message = 'Pong!'
        }
    }
    $url = 'https://test.easit.com'
}
Describe "Test-EasitGOConnection" -Tag 'module' {
    It 'should not throw' {
        {Test-EasitGOConnection -Url $url} | Should -Not -Throw
    }
    It 'should not throw with custom irm params' {
        $customParams = @{TimeoutSec = 60;SkipHeaderValidation=$true}
        {Test-EasitGOConnection -Url $url -InvokeRestMethodParameters $customParams} | Should -Not -Throw
    }
    It 'should return an PSCustomObject' {
        $output = Test-EasitGOConnection -Url $url
        $output | Should -BeOfType 'PSCustomObject'
    }
    It 'returned object should have a property called "message"' {
        $output = (Test-EasitGOConnection -Url $url).message
        $output | Should -Not -BeNullOrEmpty
    }
    It 'returned object should have a message exactly like "Pong!"' {
        $output = (Test-EasitGOConnection -Url $url).message
        $output | Should -BeExactly 'Pong!'
    }
}