function Get-EnvironmentSetting {
    <#
    .SYNOPSIS
        Creates a PSCustomObject with details about environment / project.
    .DESCRIPTION
        **Get-EnvironmentSetting** is supposed to be used in Pester test files in order to make it easier to setup tests.
    .EXAMPLE
        try {
            $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
            . $getEnvSetPath
            $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
        } catch {
            throw $_
        }
    .PARAMETER Path
        Path of test script.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$Path
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
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
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}