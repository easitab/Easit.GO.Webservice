function New-XMLElementObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter()]
        [String]$Value,
        [Parameter(Mandatory)]
        [ValidateSet('soapenv','sch')]
        [String]$Prefix,
        [Parameter(Mandatory)]
        [String]$NamespaceSchema,
        [Parameter()]
        [Hashtable]$Attributes
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ([string]::IsNullOrWhiteSpace($Name)) {
            throw "Name is null or empty"
        }
        if ([string]::IsNullOrWhiteSpace($NamespaceSchema)) {
            throw "NamespaceSchema is null or empty"
        }
        if ($null -eq $requestXMLObject) {
            throw "xmlRequestObject is null"
        }
        try {
            $XMLElement = $requestXMLObject.CreateElement("${Prefix}:${Name}","$NamespaceSchema")
        } catch {
            throw $_
        }
        if (!([String]::IsNullOrWhiteSpace($Value))) {
            $XMLElement.InnerText  = $Value
        }
        foreach ($attribute in $Attributes.Keys) {
            $XMLElement.SetAttribute($attribute,$Attributes.$attribute)
        }
        return $XMLElement
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}