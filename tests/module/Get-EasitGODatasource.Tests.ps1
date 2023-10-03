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
        Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getDatasourceResponse_moduleTest.json') -Raw | ConvertFrom-Json
    }
    $url = 'https://test.easit.com'
    $api = '902457830947852945730249875'
}
Describe "Get-EasitGODatasource" -Tag 'module' {
    It 'should not throw if input for ModuleId is valid' {
        {Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001} | Should -Not -Throw
    }
    It 'should not throw if all input is valid' {
        {Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001 -ParentRawValue '5:1'} | Should -Not -Throw
    }
    It 'should throw when input for ModuleId is invalid' {
        {Get-EasitGODatasource -Url $url -Apikey $api -ModuleId "moduleId"} | Should -Throw
    }
    It 'should return an PSCustomObject' {
        $output = Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001
        $output | Should -BeOfType 'PSCustomObject'
    }
    It 'should return an PSCustomObject with 4 datasources' {
        $output = Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001
        $output.datasource.Count | Should -BeExactly 4
    }
    It 'should return 4 PSCustomObjects if ReturnAsSeparateObjects is true' {
        $output = Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001 -ReturnAsSeparateObjects
        $output.Count | Should -BeExactly 4
    }
    It 'should not return anything when -WhatIf is used' {
        $output = Get-EasitGODatasource -Url $url -Apikey $api -ModuleId 1001 -ReturnAsSeparateObjects -WhatIf
        $output | Should -BeNullOrEmpty
    }
}