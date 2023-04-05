function New-ItemToImportAttachmentXMLObject {
    <#
    .SYNOPSIS
        Creates a attachment XML element that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a attachment XML element, assigns it to the script variable *schItemToImport*.
        The element will have a attribute called *name* with a value of the input for the Name parameter.
        If the Value parameter does not contain *[IO.Path]::DirectorySeparatorChar*, the value be treated as a base64 string.
        
        If the Value parameter contains *[IO.Path]::DirectorySeparatorChar*, the value be treated as a path. If the path failes 
        *Test-Path* an error is thrown, otherwise we convert the content of the file to base64 and set that string as innerText.
        If the value is a path and the Name parameter is empty, the filename will be used as value for the name attribute.
        
    .EXAMPLE
        foreach ($property in $InputObject.psobject.properties) {
            New-ItemToImportPropertyXMLObject -NamespaceSchema $NamespaceSchema -Name $property.Name -Value $property.Value
        }
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace (xmlns:sch).
    .PARAMETER Name
        Value to be set as value for name attribute.
    .PARAMETER Value
        Value to be set as innertext for element.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter()]
        [String]$Name,
        [Parameter()]
        [String]$Value
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $directorySeparator = [IO.Path]::DirectorySeparatorChar
        $base64string = $null
        if ($Value -match "\${directorySeparator}") {
            if (Test-Path -Path (Resolve-Path -Path $Value)) {
                try {
                    $base64string = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Resolve-Path -Path $Value)))
                } catch {
                    throw $_
                }
                if ([string]::IsNullOrWhiteSpace($Name) -or $Name -match 'null') {
                    $Name = (Get-ChildItem -Path $Value).Name
                }
            } else {
                throw "Cannot find $Value"
            }
        } else {
            $base64string = $Value
            if ([string]::IsNullOrWhiteSpace($Name)) {
                throw "Missing name for attachment"
            }
        }
        try {
            $envelopeItemAttachment = $xmlRequestObject.CreateElement("sch:Attachment","$NamespaceSchema")
            $envelopeItemAttachment.SetAttribute('name',"$Name")
            $envelopeItemAttachment.InnerText = "$base64string"
            $script:schItemToImport.AppendChild($envelopeItemAttachment) | Out-Null
        } catch {
            Write-Warning "Failed to add attachment $Name to request"
            throw $_
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}