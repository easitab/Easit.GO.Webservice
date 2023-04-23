function New-ItemToImportXMLObject {
    <#
    .SYNOPSIS
        Creates a base ItemToImport XML object that can be used for sending requests to Easit GO.
    .DESCRIPTION
        Creates a base ItemToImport XML object, based on the XML created by **New-RequestXMLObject** and **New-ImportItemRequestXMLObject**.
        This function first checks if the variable *requestXMLObject* is null or not and if so calls **New-RequestXMLObject** to set it.
        This function then checks if the variable *requestImportItemsRequestElement* is null or not and if so calls **New-ImportItemRequestXMLObject** to set it.
        It adds the element *ItemToImport* with the following attributes:

        - id
        - uid

        With help of **New-ItemToImportPropertyXMLObject** and **New-ItemToImportAttachmentXMLObject** it iterates the InputObjects properties and add them
        as a *Property element* with the property name as the attribute *name* and the property value as the elements innerText.

        If the property value is an array, each item in the array will be added as its own Property element. The elements attribute name will be the 
        name of the property holding the array. If the property value is an hashtable, each item in the hashtable will be added as its own Property element.
        The elements attribute name will be hash.key and the elements value will the keys value.

    .EXAMPLE
        $hash = @{}
        $hash.'null1' = "C:\testPath\aImage.png"
        $hash.'null2' = "C:\testPath\fileWithData.csv"
        $anArray = Get-ChildItem -Path 'C:\testPath\files\' -Recurse -Include '*.txt'
        $customObject = [PSCustomObject]@{propertyName1='propertyValue1';anArray=$anArray;attachments = $hash}
        $newItemToImportXMLObjectParams = @{
            InputObject = $contact
            ImportHandlerIdentifier = 'test'
            NamespaceURI = 'http://schemas.xmlsoap.org/soap/envelope/'
            NamespaceSchema = 'http://www.easit.com/bps/'
        }
        New-ItemToImportXMLObject @newItemToImportXMLObjectParams

        In this example we are sending an object to Easit GO that has an array, an hashtable and a string as its properties.
    .PARAMETER NamespaceURI
        URI used for the envelope namespace.
    .PARAMETER NamespaceSchema
        URI to schema used to for the body elements namespace.
    .PARAMETER RequestPrefix
        Prefix used for elements appended to the Body element.
    .PARAMETER EnvelopePrefix
        Prefix used for elements appended to the Envelope element.
    .PARAMETER ImportHandlerIdentifier
        Value set as ImportHandlerIdentifier for request.
    .PARAMETER InputObject
        Object to be "converted" to a ItemToImport.
    .PARAMETER UID
        Unique identifier for item in the XML document.
    .PARAMETER ID
        Identifier for item in the XML document.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$NamespaceURI,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter(Mandatory)]
        [String]$ImportHandlerIdentifier,
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject,
        [Parameter()]
        [Int]$UID = 1,
        [Parameter()]
        [Int]$ID = 1,
        [Parameter(Mandatory)]
        [String]$EnvelopePrefix,
        [Parameter(Mandatory)]
        [String]$RequestPrefix
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ([string]::IsNullOrWhiteSpace($NamespaceURI)) {
            throw "NamespaceURI is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($NamespaceSchema)) {
            throw "NamespaceSchema is null or empty"
        }
        if ($null -eq $requestXMLObject) {
            $newRequestXMLObjectParams = @{
                NamespaceURI = $NamespaceURI
                NamespaceSchema = $NamespaceSchema
                EnvelopePrefix = $EnvelopePrefix
                RequestPrefix = $RequestPrefix
            }
            try {
                New-RequestXMLObject @newRequestXMLObjectParams
            } catch {
                throw $_
            }
        }
        if ($null -eq $requestImportItemsRequestElement) {
            $newImportItemRequestXMLObjectParams = @{
                ImportHandlerIdentifier = $ImportHandlerIdentifier
                NamespaceURI = $NamespaceURI
                NamespaceSchema = $NamespaceSchema
                EnvelopePrefix = $EnvelopePrefix
                RequestPrefix = $RequestPrefix
            }
            try {
                New-ImportItemRequestXMLObject @newImportItemRequestXMLObjectParams
            } catch {
                throw $_
            }
        }
        $requestItemToImportElementParams = @{
            Name = 'ItemToImport'
            Prefix = $RequestPrefix
            NamespaceSchema = $NamespaceSchema
            Attributes = @{
                id = $ID
                uid = $UID
            }
        }
        try {
            Write-Debug "Creating xml element for ItemToImport"
            New-Variable -Name 'requestItemToImportElement' -Value (New-XMLElementObject @requestItemToImportElementParams) -Scope Script
            $requestImportItemsRequestElement.AppendChild($requestItemToImportElement) | Out-Null
        } catch {
            Write-Warning "Failed to create xml element for ItemToImport"
            throw $_
        }
        Write-Debug "Starting loop for creating xml element for each parameter"
        foreach ($property in $InputObject.psobject.properties) {
            if ($property.Value -is [system.array]) {
                Write-Debug "Property is a array"
                foreach ($propertyValue in $property.Value) {
                    $newitemToImportPropertyElementParams = @{
                        Name = 'Property'
                        Value = $propertyValue
                        Prefix = $RequestPrefix
                        NamespaceSchema = $NamespaceSchema
                        Attributes = @{
                            name = $property.Name
                        }
                    }
                    try {
                        $requestItemToImportElement.AppendChild((New-XMLElementObject @newitemToImportPropertyElementParams)) | Out-Null
                    } catch {
                        throw $_
                    }
                }
            } elseif ($property.Value -is [hashtable]) {
                if ($property.Name -eq 'Attachment' -OR $property.Name -eq 'Attachments') {
                    Write-Debug "Property value is a hashtable and name ($($property.Name)) is attachment(s)"
                    foreach ($attachment in $property.Value.GetEnumerator()) {
                        try {
                            New-ItemToImportAttachmentXMLObject -NamespaceSchema $NamespaceSchema -Name $attachment.Name -Value $attachment.Value -RequestPrefix $RequestPrefix
                        } catch {
                            throw $_
                        }
                    }
                } else {
                    Write-Debug "Property value is a hashtable but name ($($property.Name)) is NOT attachment(s)"
                    #foreach ($property in $property.Value.GetEnumerator()) {
                        $newitemToImportPropertyElementParams = @{
                            Name = 'Property'
                            Value = $property.Value.Value
                            Prefix = $RequestPrefix
                            NamespaceSchema = $NamespaceSchema
                            Attributes = @{
                                'name' = $property.Value.Name
                            }
                        }
                        if ($property.Value.rawValue) {
                            $newitemToImportPropertyElementParams.Attributes.Add('rawValue',$property.Value.rawValue)
                        }
                        try {
                            $requestItemToImportElement.AppendChild((New-XMLElementObject @newitemToImportPropertyElementParams)) | Out-Null
                        } catch {
                            throw $_
                        }
                    #}
                }
            } else {
                $newitemToImportPropertyElementParams = @{
                    Name = 'Property'
                    Value = $property.Value
                    Prefix = $RequestPrefix
                    NamespaceSchema = $NamespaceSchema
                    Attributes = @{
                        name = $property.Name
                    }
                }
                try {
                    $requestItemToImportElement.AppendChild((New-XMLElementObject @newitemToImportPropertyElementParams)) | Out-Null
                } catch {
                    throw $_
                }
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}