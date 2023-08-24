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
    [string]$Copyright,
    [Parameter()]
    [String[]]$FunctionsToExport
)
begin {
    $InformationPreference = 'Continue'
    Write-Information "Script start"
}
process {
    try {
        Install-Module -Name 'platyPS' -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module 'platyP'S -Force -ErrorAction Stop
    } catch {
        throw $_
    }
    $repoDirectory = Split-Path -Path $PSScriptRoot -Parent
    $sourceDirectory = Join-Path $repoDirectory -ChildPath 'source'
    if (!(Test-Path -Path $sourceDirectory)) {
        throw "Cannot find $sourceDirectory"
    }
    $docsDirectory = Join-Path -Path $repoDirectory -ChildPath 'docs'
    if (Test-Path -Path $docsDirectory) {
        Write-Information "$docsDirectory already exist"
    } else {
        try {
            Write-Information "Creating $docsDirectory"
            $null = New-Item -Path $repoDirectory -Name 'docs' -ItemType Directory
        } catch {
            throw $_
        }
    }
    $tempBuildDirectory = Join-Path $repoDirectory -ChildPath 'temp'
    if (Test-Path -Path $tempBuildDirectory) {
        try {
            Write-Information "Cleaning $tempBuildDirectory"
            Get-ChildItem -Path $tempBuildDirectory -Recurse -ErrorAction Stop | Remove-Item -Confirm:$false -Recurse -ErrorAction Stop
        } catch {
            Write-Warning "Unable to clean $tempBuildDirectory"
            throw $_
        }
    } else {
        try {
            Write-Information "Creating $tempBuildDirectory"
            $null = New-Item -Path $repoDirectory -Name 'temp' -ItemType Directory
        } catch {
            throw $_
        }
    }
    $tagDocsDirectory = Join-Path -Path $docsDirectory -ChildPath $Tag
    if (Test-Path -Path $tagDocsDirectory) {
        try {
            Write-Information "Cleaning files in $tagDocsDirectory"
            Get-ChildItem -Path $tagDocsDirectory -Recurse -File | Remove-Item -Confirm:$false
            Write-Information "Cleaning folders in $tagDocsDirectory"
            Get-ChildItem -Path $tagDocsDirectory -Recurse -Directory | Remove-Item -Confirm:$false
        } catch {
            Write-Warning "Unable to clean $tagDocsDirectory"
            throw $_
        }
    }
    try {
        $classes = Get-ChildItem -Path (Join-Path -Path "$sourceDirectory" -ChildPath 'classes') -Filter "*.ps1" -Recurse -ErrorAction Stop
        $privateFunctions = Get-ChildItem -Path (Join-Path -Path "$sourceDirectory" -ChildPath 'private') -Filter "*.ps1" -Recurse -ErrorAction Stop
        $publicFunctions = Get-ChildItem -Path (Join-Path -Path "$sourceDirectory" -ChildPath 'public') -Filter "*.ps1" -Recurse -ErrorAction Stop
    } catch {
        Write-Warning "Unable to get all classes and functions"
        throw $_
    }
    if (!$classes -and !$privateFunctions -and $publicFunctions) {
        throw "No functions or classes found"
    }
    try {
        $moduleRoot = New-Item -Path $tempBuildDirectory -Name $ModuleName -ItemType Directory
        $psm1 = New-Item -Path $moduleRoot -Name "$ModuleName.psm1" -ItemType File
    } catch {
        throw $_
    }
    Write-Information "Generating new psm1"
    foreach ($class in $classes) {
        $fileContent = $null
        try {
            $fileContent = Get-Content -Path $class.FullName -Raw
        } catch {
            Write-Warning "Failed to get content from $($class.FullName)"
            throw $_
        }
        try {
            Add-Content -Path $psm1 -Value $fileContent
        } catch {
            Write-Warning "Failed to add content to $($psm1.FullName)"
            throw $_
        }
    }
    foreach ($privateFunction in $privateFunctions) {
        $fileContent = $null
        try {
            $fileContent = Get-Content -Path $privateFunction.FullName -Raw
        } catch {
            Write-Warning "Failed to get content from $($privateFunction.FullName)"
            throw $_
        }
        try {
            Add-Content -Path $psm1 -Value $fileContent
        } catch {
            Write-Warning "Failed to add content to $($psm1.FullName)"
            throw $_
        }
    }
    foreach ($publicFunction in $publicFunctions) {
        $fileContent = $null
        try {
            $fileContent = Get-Content -Path $publicFunction.FullName -Raw
        } catch {
            Write-Warning "Failed to get content from $($publicFunction.FullName)"
            throw $_
        }
        try {
            Add-Content -Path $psm1 -Value $fileContent
        } catch {
            Write-Warning "Failed to add content to $($psm1.FullName)"
            throw $_
        }
        $FunctionsToExport += $publicFunction.BaseName
    }
    try {
        $manifestFilePath = Join-Path -Path "$moduleRoot" -ChildPath "$ModuleName.psd1"
    } catch {
        throw $_
    }
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
        FunctionsToExport = $FunctionsToExport
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
    try {
        Write-Information "Importing module ($psm1) to session"
        Import-Module $psm1 -Force
    } catch {
        throw $_
    }
    try {
        Write-Information "Generating markdown help for module $ModuleName to $tagDocsDirectory"
        $null = New-MarkdownHelp -Module $ModuleName -OutputFolder $tagDocsDirectory -Force
    } catch {
        throw $_
    }
    $privateDocsDirectory = Join-Path -Path $tagDocsDirectory -ChildPath 'private'
    if (Test-Path -Path $privateDocsDirectory) {
        Get-ChildItem -Path $privateDocsDirectory -Recurse -File | Remove-Item -Confirm:$false
    } else {
        $null = New-Item -Path $tagDocsDirectory -Name 'private' -ItemType Directory
    }
    Write-Information "Moving markdown files from $tagDocsDirectory to $privateDocsDirectory"
    foreach ($privateFunction in $privateFunctions) {
        $privateMDFile = Get-ChildItem -Path $tagDocsDirectory -Recurse -Include "$($privateFunction.BaseName).md"
        if ($privateMDFile) {
            try {
                Move-Item -Path $privateMDFile.FullName -Destination $privateDocsDirectory
            } catch {
                throw $_
            }
        } else {
            Write-Warning "Unable to find $($privateFunction.BaseName).md"
        }
    }
    $publicDocsDirectory = Join-Path -Path $tagDocsDirectory -ChildPath 'public'
    if (Test-Path -Path $publicDocsDirectory) {
        Get-ChildItem -Path $publicDocsDirectory -Recurse -File | Remove-Item -Confirm:$false
    } else {
        $null = New-Item -Path $tagDocsDirectory -Name 'public' -ItemType Directory
    }
    Write-Information "Moving markdown files from $tagDocsDirectory to $publicDocsDirectory"
    foreach ($publicFunction in $publicFunctions) {
        $publicMDFile = Get-ChildItem -Path $tagDocsDirectory -Recurse -Include "$($publicFunction.BaseName).md"
        if ($publicMDFile) {
            try {
                Move-Item -Path $publicMDFile.FullName -Destination $publicDocsDirectory
            } catch {
                throw $_
            }
        } else {
            Write-Warning "Unable to find $($publicFunction.BaseName).md"
        }
    }
    Write-Information "Module documentation for release complete"
}
end {
    Write-Information "Script end"
}