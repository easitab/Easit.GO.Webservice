BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testFunctionRoot = Split-Path -Path $PSCommandPath -Parent
    $testsRoot = Split-Path -Path $testFunctionRoot -Parent
    $testsDataRoot = Join-Path -Path $testsRoot -ChildPath 'data'
    $projectRoot = Split-Path -Path $testsRoot -Parent
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath "source"
    $codeFiles = Get-ChildItem -Path "$sourceRoot" -Include "*.ps1" -Recurse
    foreach ($codeFile in $codeFiles) {
        try {
            . $codeFile
        } catch {
            Write-Output "Unable to locate code file ($codeFileName) to test against!" -ForegroundColor Red
            return
        }
    }
    [xml]$getItemsResponse = Get-Content -Path (Join-Path -Path $testsDataRoot -ChildPath 'getItemsResponse_1_messages..xml') -Raw
    $mockObject = New-Object PSCustomObject
    try {
        $mockObject | Add-Member -MemberType NoteProperty -Name "RequestedPage" -Value "$($getItemsResponse.Envelope.Body.GetItemsResponse.requestedPage)"
        $mockObject | Add-Member -MemberType NoteProperty -Name "TotalNumberOfPages" -Value "$($getItemsResponse.Envelope.Body.GetItemsResponse.totalNumberOfPages)"
        $mockObject | Add-Member -MemberType NoteProperty -Name "TotalNumberOfItems" -Value "$($getItemsResponse.Envelope.Body.GetItemsResponse.totalNumberOfItems)"
        $mockObject | Add-Member -MemberType NoteProperty -Name "DatabaseId" -Value "76:7"
    } catch {
        Write-Error $_
        return
    }
    try {
        $mockObject = Add-PropertyFromColumn -XML $getItemsResponse -InputObject $mockObject
    } catch {
        Write-Error $_
        return
    }
}
Describe "Add-PropertyFromColumn" {
    It 'should have a parameter named XML that is mandatory and accepts a XML object.' {
        Get-Command "$commandName" | Should -HaveParameter XML -Mandatory -Type XML
    }
    It 'should have a parameter named InputObject that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$commandName" | Should -HaveParameter InputObject -Mandatory -Type PSCustomObject
    }
    It 'should return a object with 15 properties' {
        ($mockObject.PsObject.Properties.GetEnumerator() | Where-Object -Property Name -NotMatch '.*_details').Count | Should -BeExactly 15
    }
    It 'should return a object with 11 details properties' {
        ($mockObject.PsObject.Properties.GetEnumerator() | Where-Object -Property Name -Match '.*_details').Count | Should -BeExactly 11
    }
    It 'should return a object with DatabaseId 76:7' {
        $mockObject.DatabaseId | Should -BeExactly '76:7'
    }
}