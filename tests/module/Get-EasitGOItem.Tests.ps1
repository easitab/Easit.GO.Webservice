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
        $bodyObject = $BaseParameters.Body | ConvertFrom-Json
        if ($bodyObject.page -eq 3) {
            return Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getItemsResponse_page3_moduleTest.json') -Raw | ConvertFrom-Json
        } elseif ($bodyObject.pageSize -eq 75) {
            return Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getItemsResponse_pageSize75_moduleTest.json') -Raw | ConvertFrom-Json
        } else {
            return Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'getItemsResponse_moduleTest.json') -Raw | ConvertFrom-Json
        }
    }
    $url = 'https://test.easit.com'
    $api = '902457830947852945730249875'
    $ImportViewIdentifier = 'testView'
}
Describe "Get-EasitGOItem" -Tag 'module' {
    It 'should not throw if minimum input is valid' {
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier} | Should -Not -Throw
    }
    It 'should not throw when page is specified' {
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -Page 1} | Should -Not -Throw
    }
    It 'should not throw when pageSize is specified' {
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -PageSize 75} | Should -Not -Throw
    }
    It 'should not throw when a ColumnFilter is provided' {
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -ColumnFilter $columnFilters} | Should -Not -Throw
    }
    It 'should not throw when a SortColumn is provided' {
        $sortColumn = New-SortColumn -Name 'Updated' -Order 'Descending'
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -SortColumn $sortColumn} | Should -Not -Throw
    }
    It 'should not throw when multiple ColumnFilters is provided' {
        $columnFilters = @()
        $columnFilters += New-ColumnFilter -ColumnName 'Status' -Comparator 'IN' -ColumnValue 'Open'
        $columnFilters += New-ColumnFilter -ColumnName 'Priority' -Comparator 'IN' -ColumnValue 'High'
        {Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -ColumnFilter $columnFilters} | Should -Not -Throw
    }
    It 'should return an PSCustomObject' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output | Should -BeOfType 'PSCustomObject'
    }
    It 'should return an PSCustomObject with an columns property that is not null' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output.columns | Should -Not -BeNullOrEmpty
    }
    It 'should return an PSCustomObject with an items property that is not null' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output.items | Should -Not -BeNullOrEmpty
    }
    It 'items property should have 25 objects' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output.items.item.Count | Should -BeExactly 25
    }
    It 'requestedPage property should be 0 as no page was specified' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output.requestedPage | Should -BeExactly 0
    }
    It 'page property should be 1 as no page was specified' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier
        $output.page | Should -BeExactly 1
    }
    It 'page property should be 3 when page = 3' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -Page 3
        $output.page | Should -BeExactly 3
    }
    It 'pageSize property should be 75' {
        $page3Output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -PageSize 75
        $page3Output.pageSize | Should -BeExactly 75
    }
    It 'should return 25 objects when ReturnAsSeparateObjects is true' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -ReturnAsSeparateObjects
        $output.Count | Should -BeExactly 25
    }
    It 'should not return anything when -WhatIf is used' {
        $output = Get-EasitGOItem -Url $url -Apikey $api -ImportViewIdentifier $ImportViewIdentifier -ReturnAsSeparateObjects -WhatIf
        $output | Should -BeNullOrEmpty
    }
}