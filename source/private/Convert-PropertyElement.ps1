function Convert-PropertyElement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Xml.XmlElement]$Property,
        [Parameter()]
        [Switch]$ExcludeName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        $convertedPropertyElement = New-Object PSCustomObject
        if ($ExcludeName) {
            Write-Debug "Parameter ExcludeName is provide, will not include Name in return object"
        } else {
            try {
                $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "Name" -Value $Property.name
            } catch {
                throw $_
            }
        }
        try {
            $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "Value" -Value $Property.InnerText
        } catch {
            throw $_
        }
        try {
            $convertedPropertyElement | Add-Member -MemberType NoteProperty -Name "RawValue" -Value $Property.rawValue
        } catch {
            throw $_
        }
        $convertedPropertyElement
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}