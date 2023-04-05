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
Describe "New-ItemToImportXMLObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceURI that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceURI -Mandatory -Type String
    }
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should have a parameter named ImportHandlerIdentifier that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -Mandatory -Type String
    }
    It 'should check if input for NamespaceURI is whitespace, and if so throw an error' {
        {New-PingRequestObject -NamespaceURI ' ' -NamespaceSchema 'validinput' -ImportHandlerIdentifier 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for NamespaceURI is null, and if so throw an error' {
        {New-PingRequestObject -NamespaceURI $null -NamespaceSchema 'validinput' -ImportHandlerIdentifier 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for NamespaceSchema is whitespace, and if so throw an error' {
        {New-PingRequestObject -NamespaceURI 'validinput' -NamespaceSchema ' ' -ImportHandlerIdentifier 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for NamespaceSchema is null, and if so throw an error' {
        {New-PingRequestObject -NamespaceURI 'validinput' -NamespaceSchema $null -ImportHandlerIdentifier 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for ImportHandlerIdentifier is whitespace, and if so throw an error' {
        {New-PingRequestObject -ImportHandlerIdentifier ' ' -NamespaceURI 'validinput' -NamespaceSchema 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for ImportHandlerIdentifier is null, and if so throw an error' {
        {New-PingRequestObject -ImportHandlerIdentifier $null -NamespaceURI 'validinput' -NamespaceSchema 'validinput' -ErrorAction Stop} | Should -Throw
    }
    It 'should have a parameter named InputObject that is mandatory and accepts a PSCustomObject.' {
        Get-Command "$commandName" | Should -HaveParameter InputObject -Mandatory -Type PSCustomObject
    }
    It 'should have a parameter named UID that accepts an Integer.' {
        Get-Command "$commandName" | Should -HaveParameter UID -Type Int
    }
    It 'should have a parameter named ID that accepts an Integer.' {
        Get-Command "$commandName" | Should -HaveParameter ID -Type Int
    }
}