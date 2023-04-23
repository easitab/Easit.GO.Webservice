BeforeAll {
    $testFilePath = $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $codeFileName = Split-Path -Path $testFilePath -Leaf
    $commandName = ((Split-Path -Leaf $PSCommandPath) -replace '.ps1','') -replace '.Tests', ''
    $testFunctionRoot = Split-Path -Path $PSCommandPath -Parent
    $testsRoot = Split-Path -Path $testFunctionRoot -Parent
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
    $newGetItemsRequestXMLObjectParams = @{
        EnvelopePrefix = 'soapenv'
        RequestPrefix = 'sch'
        NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
        NamespaceSchema = 'http://www.easit.com/bps/schemas'
    }
}
Describe "New-GetItemsRequestXMLObject" -Tag 'function','private' {
    It 'should have a parameter named NamespaceURI that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceURI -Mandatory -Type String
    }
    It 'should have a parameter named NamespaceSchema that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter NamespaceSchema -Mandatory -Type String
    }
    It 'should have a parameter named ItemViewIdentifier that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter ItemViewIdentifier -Mandatory -Type String
    }
    It 'should have a parameter named RequestPrefix that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter RequestPrefix -Mandatory -Type String
    }
    It 'should have a parameter named EnvelopePrefix that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter EnvelopePrefix -Mandatory -Type String
    }
    It 'should have a parameter named Page that accepts an Int.' {
        Get-Command "$commandName" | Should -HaveParameter Page -Type Int
    }
    It 'should have a parameter named PageSize that is mandatory and accepts an Int.' {
        Get-Command "$commandName" | Should -HaveParameter PageSize -Type Int
    }
    It 'should have a parameter named SortColumn' {
        Get-Command "$commandName" | Should -HaveParameter SortColumn
    }
    It 'should have a parameter named ColumnFilters' {
        Get-Command "$commandName" | Should -HaveParameter ColumnFilters
    }
    It 'should have a parameter named FreeTextFilter that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter FreeTextFilter -Type String
    }
    It 'should have a parameter named IdFilter that is mandatory and accepts a string.' {
        Get-Command "$commandName" | Should -HaveParameter IdFilter -Type String
    }
    It 'should not throw if all input is valid' {
        {New-GetItemsRequestXMLObject @newGetItemsRequestXMLObjectParams -ItemViewIdentifier 'newGetItemsRequestXMLObjectParams'} | Should -Not -Throw
    }
}