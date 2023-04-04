BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testFunctionRoot = Split-Path -Path $PSCommandPath -Parent
    $testRoot = Split-Path -Path $testFunctionRoot -Parent
    $testDataRoot = Join-Path -Path "$testRoot" -ChildPath "data"
    $projectRoot = Split-Path -Path $testRoot -Parent
    $sourceRoot = Join-Path -Path "$projectRoot" -ChildPath "source"
    $codeFile = Get-ChildItem -Path "$sourceRoot" -Include "$codeFileName" -Recurse
    if (Test-Path $codeFile) {
        . $codeFile
    } else {
        Write-Output "Unable to locate code file ($codeFileName) to test against!" -ForegroundColor Red
    }
}
Describe "New-XMLRequestObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceURI that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceURI -Mandatory -Type String
    }
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should check if input for NamespaceURI is null or whitespace, and if so throw an error' {
        {New-XMLRequestObject -NamespaceURI ' ' -NamespaceSchema 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for NamespaceSchema is null or whitespace, and if so throw an error' {
        {New-XMLRequestObject -NamespaceURI 'validinput' -NamespaceSchema ' ' -ErrorAction Stop} | Should -Throw
    }
}