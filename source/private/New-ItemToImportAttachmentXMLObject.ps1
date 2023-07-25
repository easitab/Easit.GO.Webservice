function New-ItemToImportAttachmentXMLObject {
    <#
    .SYNOPSIS
        Creates a attachment XML element for attachments.
    .DESCRIPTION
        Creates a attachment XML element and returns it.
        The element will have a attribute called *name* with the value of the input for the Name parameter.
        If the Value parameter does not contain *[IO.Path]::DirectorySeparatorChar*, the value will be treated as a base64 string.
        
        If the Value parameter contains *[IO.Path]::DirectorySeparatorChar*, the value be treated as a path. If the path failes
        *Test-Path* an error is thrown, otherwise we convert the content of the file to base64 and set that string as innerText.
        If in put for Value is a path and the Name parameter is empty, the filename will be used as value for the name attribute.
    .EXAMPLE
        if ($property.Value -is [hashtable]) {
            if ($property.Name -eq 'Attachment' -OR $property.Name -eq 'Attachments') {
                foreach ($attachment in $property.Value.GetEnumerator()) {
                    New-ItemToImportAttachmentXMLObject -NamespaceSchema $NamespaceSchema -Name $attachment.Name -Value $attachment.Value -RequestPrefix $RequestPrefix
                }
            }
        }
    .PARAMETER NamespaceSchema
        URI used for the body elements namespace.
    .PARAMETER Name
        Value to be set as value for name attribute.
    .PARAMETER Value
        Value to be set as innertext for element.
    .PARAMETER RequestPrefix
        Prefix used for elements appended to the Body element.
    .OUTPUTS
        [System.Xml.XmlElement]
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter()]
        [String]$Name,
        [Parameter()]
        [String]$Value,
        [Parameter(Mandatory)]
        [String]$RequestPrefix
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $directorySeparator = [IO.Path]::DirectorySeparatorChar
        $base64string = $null
        if ([string]::IsNullOrWhiteSpace($Name) -and [string]::IsNullOrWhiteSpace($Value)) {
            throw "Name and value is null or empty"
        }
        if ($Value -match "\${directorySeparator}") {
            if (Test-Path -Path (Resolve-Path -Path $Value)) {
                try {
                    $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Resolve-Path -Path $Value)))
                } catch {
                    Write-Warning "Failed to convert file content to base 64"
                    throw $_
                }
                if ([string]::IsNullOrWhiteSpace($Name) -or $Name -match 'null') {
                    $Name = (Get-ChildItem -Path $Value).Name
                }
            } else {
                throw "Cannot find $Value"
            }
        }
        if (!($Value -match "\${directorySeparator}")) {
            if ([string]::IsNullOrWhiteSpace($Name)) {
                throw "Missing name for attachment"
            }
            $base64string = $Value
        }
        try {
            $newAttachmentElementParams = @{
                Name = 'Attachment'
                Value = $base64string
                Prefix = $RequestPrefix
                NamespaceSchema = $NamespaceSchema
                Attributes = @{
                    'name' = $Name
                }
                ErrorAction = 'Stop'
            }
        } catch {
            Write-Warning "Failed to set newAttachmentElementParams"
            throw $_
        }
        Write-Debug "Creating xml element for Attachment ($Name)"
        try {
            New-XMLElementObject @newAttachmentElementParams
        } catch {
            Write-Warning "Failed to create xml element for Attachment ($Name)"
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}