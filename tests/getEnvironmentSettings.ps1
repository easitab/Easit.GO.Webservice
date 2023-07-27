function Get-EnvironmentSettings {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$Path
    )
    begin {
        
    }
    process {
        try {
            $testFileObject = Get-ChildItem $Path
        } catch {
            throw $_
        }
        $returnObject = [PSCustomObject]@{
            TestFilePath = $testFileObject.FullName
            TestFilename = $testFileObject.Name
            CodeFileName = $testFileObject.Name.Replace('.Tests.ps1','.ps1')
            TestsFunctionDirectory = $testFileObject.Directory.FullName
        }
        try {
            $returnObject | Add-Member -MemberType Noteproperty -Name "TestsDirectory" -Value (Split-Path -Path $returnObject.TestsFunctionDirectory -Parent)
            $returnObject | Add-Member -MemberType Noteproperty -Name "CommandName" -Value $returnObject.CodeFileName.Replace('.ps1', '')
            $returnObject | Add-Member -MemberType Noteproperty -Name "TestDataDirectory" -Value (Join-Path -Path $returnObject.TestsDirectory -ChildPath "data")
            $returnObject | Add-Member -MemberType Noteproperty -Name "ProjectDirectory" -Value (Split-Path -Path $returnObject.TestsDirectory -Parent)
            $returnObject | Add-Member -MemberType Noteproperty -Name "SourceDirectory" -Value (Join-Path -Path $returnObject.ProjectDirectory -ChildPath "source")
            $returnObject | Add-Member -MemberType Noteproperty -Name "CodeFilePath" -Value (Get-ChildItem -Path $returnObject.SourceDirectory -Include $returnObject.CodeFileName -Recurse)
        } catch {
            throw $_
        }
        return $returnObject
    }
    end {
        
    }
}