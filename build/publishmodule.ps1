[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$CompanyName,
    [Parameter(Mandatory)]
    [string]$ModuleName,
    [Parameter(Mandatory)]
    [string]$Tag,
    [Parameter(Mandatory)]
    [string]$PSGalleryKey,
    [Parameter(Mandatory)]
    [string]$GitHubBaseURI,
    [Parameter(Mandatory)]
    [string]$TechspaceBaseURI,
    [Parameter(Mandatory)]
    [string]$ModuleDescription,
    [Parameter(Mandatory)]
    [string]$ModulePSVersion,
    [Parameter(Mandatory)]
    [string]$ModuleAuthor,
    [Parameter(Mandatory)]
    [string]$Copyright
)

begin {
    $InformationPreference = 'Continue'
    Write-Information "Publish module script start"
}

process {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
    $sourceRoot = Join-Path $repoRoot -ChildPath 'source'
    $tempBuildDirectory = Join-Path $repoRoot -ChildPath 'temp'
    if (Test-Path -Path $tempBuildDirectory) {
        try {
            Get-ChildItem -Path $tempBuildDirectory -Recurse -ErrorAction Stop | Remove-Item -Confirm:$false -Recurse -ErrorAction Stop
        } catch {
            Write-Warning "Unable to clean $tempBuildDirectory"
            throw $_
        }
    }
    if (!(Test-Path -Path $sourceRoot)) {
        throw "Cannot find $sourceRoot"
    }
    try {
        $allScripts = Get-ChildItem -Path "$sourceRoot" -Filter "*.ps1" -Recurse -ErrorAction Stop
    } catch {
        throw $_
    }
    if (!$allScripts) {
        throw "No scripts or functions found"
    }
    $moduleRoot = New-Item -Path $tempBuildDirectory -Name $ModuleName -ItemType Directory
    $psm1 = New-Item -Path $moduleRoot -Name "$ModuleName.psm1" -ItemType File
    Write-Information "Generating new psm1"
    foreach ($script in $allScripts) {
        $scriptContent = $null
        try {
            $scriptContent = Get-Content -Path $script.FullName -Raw
        } catch {
            Write-Warning "Failed to get content from $($script.FullName)"
            throw $_
        }
        try {
            Add-Content -Path $psm1 -Value $scriptContent
        } catch {
            Write-Warning "Failed to add content to $($psm1.FullName)"
            throw $_
        }
    }
    $manifestFilePath = Join-Path -Path "$moduleRoot" -ChildPath "$ModuleName.psd1"
    $manifest = @{
        Path              = "$manifestFilePath"
        RootModule        = "$moduleName.psm1"
        CompanyName       = "$CompanyName"
        Author            = "$ModuleAuthor"
        ModuleVersion     = "$Tag"
        HelpInfoUri       = "$TechspaceBaseURI/psmodules/intro/"
        LicenseUri        = "$GitHubBaseURI/$ModuleName/blob/main/LICENSE"
        ProjectUri        = "$GitHubBaseURI/$ModuleName"
        Description       = "$ModuleDescription"
        PowerShellVersion = "$ModulePSVersion"
        Copyright         = "$Copyright"
    }
    try {
        Write-Information "Creating new module manifest"
        New-ModuleManifest @manifest -ErrorAction Stop | Out-Null
    } catch {
        Write-Warning "Failed to create new module manifest"
        throw $_
    }
    if (Test-ModuleManifest -Path "$manifestFilePath") {
        Write-Information "Publishing module to PSGallery"
        try {
            Publish-Module -Path "$moduleRoot" -NuGetApiKey "$PSGalleryKey"
        } catch {
            Write-Warning "Failed to publish module to gallery"
            throw $_
        }
        Write-Information "Module published!"
    }
}

end {
    Write-Information "Publish module script end"
}
