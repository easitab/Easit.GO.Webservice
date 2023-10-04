[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$ModuleName,
    [Parameter(Mandatory)]
    [string]$Tag
)
begin {
    $InformationPreference = 'Continue'
    Write-Information "Script start"
}
process {
    try {
        Install-Module -Name 'platyPS' -Scope CurrentUser -Force -ErrorAction Stop
        Import-Module 'platyPS' -Force -ErrorAction Stop
    } catch {
        throw $_
    }
    $repoDirectory = Split-Path -Path $PSScriptRoot -Parent
    $publishedModulesDirectory = Join-Path -Path $repoDirectory -ChildPath 'publishedModules'
    $moduleVersionDirectory = Join-Path -Path $publishedModulesDirectory -ChildPath $Tag
    if (!(Test-Path -Path $moduleVersionDirectory)) {
        throw "Cannot find $moduleVersionDirectory"
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

    } else {
        throw "temp build directory ($tempBuildDirectory) does not exists"
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
    $publishedModuleVersionDirectory = Join-Path -Path $tempBuildDirectory -ChildPath $ModuleName
    if (Test-Path -Path $publishedModuleVersionDirectory) {
        try {
            Write-Information "Importing module to session"
            Import-Module -Name $publishedModuleVersionDirectory -Force -Verbose -ErrorAction Stop
        } catch {
            throw $_
        }
    } else {
        throw "$publishedModuleVersionDirectory does not exists"
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