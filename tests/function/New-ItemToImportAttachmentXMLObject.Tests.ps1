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
    $params = @{
        RequestPrefix = 'sch'
        NamespaceSchema = 'http://www.easit.com/bps/schemas'
    }
}
Describe "New-ItemToImportAttachmentXMLObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should have a parameter named RequestPrefix that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter RequestPrefix -Mandatory -Type String
    }
    It 'should have a parameter named Name that accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter Name -Type String
    }
    It 'should have a parameter named Value that accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter Value -Type String
    }
    It 'should throw if both Name and Value is missing' {
        {New-ItemToImportAttachmentXMLObject @params} | Should -Throw
    }
}