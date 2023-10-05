$sourceDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'source'
$testsDirectory = Join-Path -Path $PSScriptRoot -ChildPath 'tests'
$functionTestsDirectory = Join-Path -Path $testsDirectory -ChildPath 'function'
$allCoverageReports = @()
foreach ($functionTest in (Get-ChildItem -Path "${functionTestsDirectory}\*" -Recurse)) {
    $baseName = ($functionTest.Name).Replace('.Tests.ps1','.ps1')
    $sourceFile = Get-ChildItem -Path "${sourceDirectory}\*" -Recurse -Include "$baseName"
    $config = [PesterConfiguration]::Default
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.Path = $sourceFile.FullName
    $config.Run.Path = $functionTest.FullName
    $config.Run.PassThru = $true
    try {
        $allCoverageReports += Invoke-Pester -Configuration $config
    } catch {
        throw $_
    }
}
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine('|  | Function | CodeCoverage | Tests | Passed | Overall result |')
[void]$sb.AppendLine('|---|:---:|:---:|:---:|:---:|:---:|')
foreach ($coverageReport in $allCoverageReports) {
    $functionName = ($coverageReport.Containers[0].Item.Name).Replace('.Tests.ps1','')
    [void]$sb.AppendLine("| | $functionName | $($coverageReport.CodeCoverage) | $($coverageReport.TotalCount) | $($coverageReport.PassedCount) | $($coverageReport.Result) |")
}
Remove-Item .\coverage.xml -Confirm:$false
$sb.ToString()