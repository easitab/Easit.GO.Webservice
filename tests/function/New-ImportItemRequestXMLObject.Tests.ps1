BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testFunctionRoot = Split-Path -Path $PSCommandPath -Parent
    $testRoot = Split-Path -Path $testFunctionRoot -Parent
    $testDataRoot = Join-Path -Path "$testRoot" -ChildPath "data"
    $projectRoot = Split-Path -Path $testRoot -Parent
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
    $newImportItemsRequestXMLObjectParams = @{
        EnvelopePrefix = 'soapenv'
        RequestPrefix = 'sch'
        NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
        NamespaceSchema = 'http://www.easit.com/bps/schemas'
    }
}
Describe "New-ImportItemRequestXMLObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceURI that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceURI -Mandatory -Type String
    }
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should have a parameter named ImportHandlerIdentifier that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter ImportHandlerIdentifier -Mandatory -Type String
    }
    It 'should have a parameter named RequestPrefix that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter RequestPrefix -Mandatory -Type String
    }
    It 'should have a parameter named EnvelopePrefix that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter EnvelopePrefix -Mandatory -Type String
    }
    It 'should not throw if all input is valid' {
        {New-ImportItemRequestXMLObject @newImportItemsRequestXMLObjectParams -ImportHandlerIdentifier 'newImportItemsRequestXMLObjectParams'} | Should -Not -Throw
    }
    It 'should throw if input for ItemViewIdentifier is whitespace' {
        {New-ImportItemRequestXMLObject @newImportItemsRequestXMLObjectParams -ImportHandlerIdentifier ' '} | Should -Throw
    }
    It 'should throw if input for ItemViewIdentifier is nothing' {
        {New-ImportItemRequestXMLObject @newImportItemsRequestXMLObjectParams -ImportHandlerIdentifier ''} | Should -Throw
    }
    It 'should throw if input for ItemViewIdentifier is $null' {
        {New-ImportItemRequestXMLObject @newImportItemsRequestXMLObjectParams -ImportHandlerIdentifier $null} | Should -Throw
    }
}