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
}
Describe "Convert-AttachmentElement" {
    It 'should have a parameter named Attachment that is mandatory and accepts a System.Xml.XmlElement object.' {
        Get-Command "$commandName" | Should -HaveParameter Attachment -Mandatory -Type 'System.Xml.XmlElement'
    }
}