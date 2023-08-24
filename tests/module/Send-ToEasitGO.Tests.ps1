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
    $1000Items = Import-Csv -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'contacts.csv') -Delimiter ';'
    function Invoke-EasitGOWebRequest {
        param (
            [Parameter(Mandatory)]
            [hashtable]$BaseParameters,
            [Parameter()]
            [hashtable]$CustomParameters
        )
        $BaseParameters.Body | ConvertFrom-Json
    }
    $url = 'https://test.easit.com'
    $api = '902457830947852945730249875'
    $ImportHandlerIdentifier = 'testHandler'
    $items = @()
    $item = [PSCustomObject]@{prop1='value1';prop2='value"'}
    $items += $item
    $items += [PSCustomObject]@{prop1='value1';prop2='value"'}
    $sendItemParams = @{
        Url = $url
        Apikey = $api
        ImportHandlerIdentifier = $ImportHandlerIdentifier
    }
    $ctjParams = @{
        Depth = 4
        EscapeHandling = 'EscapeNonAscii'
        WarningAction = 'SilentlyContinue'
    }
    $irmParams = @{
        SkipHttpErrorCheck = $true
        SkipHeaderValidation = $true
    }
}
Describe "Send-ToEasitGO" -Tag 'module' {
    It 'should not throw when Item is used' {
        {Send-ToEasitGO @sendItemParams -Item $item} | Should -Not -Throw
    }
    It 'should not throw when CustomItem is used' {
        $item = @{prop1='value1';prop2='value"'}
        {Send-ToEasitGO @sendItemParams -CustomItem $item} | Should -Not -Throw
    }
    It 'should throw when passing a PSCustomObject to parameter CustomItem' {
        {Send-ToEasitGO @sendItemParams -CustomItem $item} | Should -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item' {
        {Send-ToEasitGO @sendItemParams -Item $items} | Should -Not -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item and SendInBatchesOf is specified' {
        {Send-ToEasitGO @sendItemParams -Item $items -SendInBatchesOf 50} | Should -Not -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item, SendInBatchesOf and IDStart is specified' {
        {Send-ToEasitGO @sendItemParams -Item $items -SendInBatchesOf 50 -IDStart 2} | Should -Not -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item and InvokeRestMethodParameters is specified' {
        {Send-ToEasitGO @sendItemParams -Item $items -InvokeRestMethodParameters $irmParams} | Should -Not -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item and ConvertToJsonParameters is specified' {
        {Send-ToEasitGO @sendItemParams -Item $items -ConvertToJsonParameters $ctjParams} | Should -Not -Throw
    }
    It 'should not throw when passing multiple PSCustomObjects to parameter Item, InvokeRestMethodParameters and ConvertToJsonParameters is specified' {
        {Send-ToEasitGO @sendItemParams -Item $items -InvokeRestMethodParameters $irmParams -ConvertToJsonParameters $ctjParams} | Should -Not -Throw
    }
    It 'itemToImport should have 2 items' {
        $output = Send-ToEasitGO @sendItemParams -Item $items
        $output.itemToImport.Count | Should -BeExactly 2
    }
    It 'last item of 2 in itemToImport should have id equals 6 when IDStart is 5' {
        $output = Send-ToEasitGO @sendItemParams -Item $items -IDStart 5
        $output.itemToImport[-1].id | Should -BeExactly 6
    }
    It 'itemToImport.Count should be 75 when SendInBatchesOf is 75' {
        $output = Send-ToEasitGO @sendItemParams -Item $1000Items -SendInBatchesOf 75
        $output[0].itemToImport.Count | Should -BeExactly 75
    }
}