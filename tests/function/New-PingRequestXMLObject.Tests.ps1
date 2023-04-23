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
            . "$($codeFile.FullName)"
        } catch {
            Write-Output "Unable to locate code file ($codeFileName) to test against!" -ForegroundColor Red
            return
        }
    }
    $NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
    $NamespaceSchema = 'http://www.easit.com/bps/schemas'
    $EnvelopePrefix = 'soapenv'
    $RequestPrefix = 'sch'
}
Describe "New-PingRequestXMLObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceURI that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceURI -Mandatory -Type String
    }
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should check if input for NamespaceURI is null or whitespace, and if so throw an error' {
        {New-PingRequestXMLObject -NamespaceURI ' ' -NamespaceSchema $NamespaceSchema -EnvelopePrefix $EnvelopePrefix -RequestPrefix $RequestPrefix -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for NamespaceSchema is null or whitespace, and if so throw an error' {
        {New-PingRequestXMLObject -NamespaceURI $NamespaceURI -NamespaceSchema ' ' -EnvelopePrefix $EnvelopePrefix -RequestPrefix $RequestPrefix -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for EnvelopePrefix is null or whitespace, and if so throw an error' {
        {New-PingRequestXMLObject -NamespaceURI $NamespaceURI -NamespaceSchema $NamespaceSchema -EnvelopePrefix ' ' -RequestPrefix $RequestPrefix -ErrorAction Stop} | Should -Throw
    }
    It 'should check if input for RequestPrefix is null or whitespace, and if so throw an error' {
        {New-PingRequestXMLObject -NamespaceURI $NamespaceURI -NamespaceSchema $NamespaceSchema -EnvelopePrefix $EnvelopePrefix -RequestPrefix ' ' -ErrorAction Stop} | Should -Throw
    }
    It 'should not throw if all input is valid' {
        {New-PingRequestXMLObject -NamespaceURI $NamespaceURI -NamespaceSchema $NamespaceSchema -EnvelopePrefix $EnvelopePrefix -RequestPrefix $RequestPrefix -ErrorAction Stop} | Should -Not -Throw
    }
}