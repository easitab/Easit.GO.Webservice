BeforeAll {
    try {
        $getEnvSetPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSCommandPath -Parent) -Parent) -ChildPath 'getEnvironmentSetting.ps1'
        . $getEnvSetPath
        $envSettings = Get-EnvironmentSetting -Path $PSCommandPath
    } catch {
        throw $_
    }
    if (Test-Path $envSettings.CodeFilePath) {
        . $envSettings.CodeFilePath
    } else {
        Write-Output "Unable to locate code file ($($envSettings.CodeFilePath)) to test against!" -ForegroundColor Red
    }
    function Invoke-WebRequest {
        [CmdletBinding()]
        param (
            $parameter1,
            $parameter2,
            $parameter3,
            $parameter4
        )
        begin {}
        process {
            $content = Get-Content -Path (Join-Path -Path $envSettings.TestDataDirectory -ChildPath 'ldapConfiguration.xml') -Raw
            $enc = [system.Text.Encoding]::UTF8
            $returnObj = New-Object PSCustomObject
            $returnObj | Add-Member -MemberType NoteProperty -Name "Content" -Value ($enc.GetBytes($content))
            $returnObj
        }
        end {}
    }
    $bP = @{
        parameter1 = 'value1'
        parameter2 = 'value2'
    }
    $cP = @{
        parameter3 = 'value3'
        parameter4 = 'value4'
    }
}
Describe "Invoke-EasitGOXmlWebRequest" -Tag 'function','private' {
    It 'should have a parameter named BaseParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter BaseParameters -Type [System.Collections.Hashtable]
    }
    It 'should have a parameter named CustomParameters that accepts a hashtable' {
        Get-Command "$($envSettings.CommandName)" | Should -HaveParameter CustomParameters -Type [System.Collections.Hashtable]
    }
    It 'help section should have a SYNOPSIS' {
        ((Get-Help "$($envSettings.CommandName)" -Full).SYNOPSIS).Length | Should -BeGreaterThan 0
    }
    It 'help section should have a DESCRIPTION' {
        ((Get-Help "$($envSettings.CommandName)" -Full).DESCRIPTION).Length | Should -BeGreaterThan 0
    }
    It 'help section should have EXAMPLES' {
        ((Get-Help "$($envSettings.CommandName)" -Full).EXAMPLES).Length | Should -BeGreaterThan 0
    }
    It 'should not throw with only base parameters' {
        {Invoke-EasitGOXmlWebRequest -BaseParameters $bP} | Should -Not -Throw
    }
    It 'should not throw with base and custom parameters' {
        {Invoke-EasitGOXmlWebRequest -BaseParameters $bP -CustomParameters $cP} | Should -Not -Throw
    }
    It 'should throw due to invalid parameters' {
        {Invoke-EasitGOXmlWebRequest -BaseParameters @{parameter5='value5'}} | Should -Throw
    }
    It 'should return a XML object' {
        Invoke-EasitGOXmlWebRequest -BaseParameters $bP -CustomParameters $cP | Should -BeOfType [System.XML.XmlDocument]
    }
}