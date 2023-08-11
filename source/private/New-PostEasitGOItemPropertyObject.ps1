function New-PostEasitGOItemPropertyObject {
    <#
    .SYNOPSIS
        Creates a PropertyObject (PSCustomObject) from a property name and value.
    .DESCRIPTION
        **New-PostEasitGOItemPropertyObject** creates a PropertyObject (PSCustomObject) that should be added to the property array for a itemToImport item.
    .EXAMPLE
        foreach ($property in $Item.psobject.properties.GetEnumerator()) {
            $returnObject.property.Add((New-PostEasitGOItemPropertyObject -InputObject $property))
        }
    .PARAMETER InputObject
        Object with name and value to be used for new PSCustomObject.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        if ([string]::IsNullOrEmpty($InputObject.value) -and [string]::IsNullOrEmpty($InputObject.name)) {
            Write-Warning "Name and value for property is null, skipping.."
            return
        }
        try {
            [PSCustomObject]@{
                content = $InputObject.Value
                name = $InputObject.Name
            }
        } catch {
            throw $_
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}