function New-FlatGetItemsReturnObject {
    <#
    .SYNOPSIS
        Creates an new PSCustomObject returned by *Convert-GetItemsResponse*.
    .DESCRIPTION
        **New-FlatGetItemsReturnObject** creates a new "flat" PSCustomObject with all properties as members directly to the object.
        Non "flat" PSCustomObject: $myObject.property.GetEnumerator() | | Where-Object -Property Name -EQ -Value 'wantedProperty'
        "Flat" PSCustomObject: $myObject.wantedProperty

        "Hidden" properties added to the returned PSCustomObject are:
        * RequestedPage
        * TotalNumberOfPages
        * TotalNumberOfItems
        * DatabaseId
        * PropertyObjects
        * propertyName_rawValue (one for each property)
        
        If a property occurres more than one time, the property value will be an array of all values with that name.
    .EXAMPLE
        $Response.items.item.GetEnumerator() | ForEach-Object -Parallel {
            try {
                New-FlatGetItemsReturnObject -Response $using:Response -Item $_
            } catch {
                throw $_
            }
        }
    .PARAMETER Response
        Response to be used as basis for a new object.
    .PARAMETER Item
        Item in response to be converted.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [OutputType('PSCustomObject')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Response,
        [Parameter(Mandatory)]
        [PSCustomObject]$Item
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $tempHash = @{
            RequestedPage = $Response.requestedPage
            TotalNumberOfPages = $Response.totalNumberOfPages
            TotalNumberOfItems = $Response.totalNumberOfItems
            DatabaseId = $Item.id
            PropertyObjects = [System.Collections.Generic.List[PSCustomObject]]::new()
        }
        foreach ($property in $item.property.GetEnumerator()){
            try {
                $tempHash.PropertyObjects.Add($property)
            } catch {
                throw $_
            }
            if ($tempHash."$($property.name)") {
                Write-Debug "Property $($property.name) already handled"
                continue
            } else {
                [string[]]$visible += $property.Name
            }
            try {
                $properties = $item.property | Where-Object -Property Name -EQ -Value $property.name
            } catch {
                throw $_
            }
            if ($properties.Count -eq 1) {
                try {
                    $tempHash.Add($property.name,$property.content)
                    $tempHash.Add("$($property.name)_rawValue",$property.rawValue)
                } catch {
                    throw $_
                }
            }
            if ($properties.Count -gt 1) {
                $tempContentList = [System.Collections.Generic.List[String]]::new()
                $tempRawValueList = [System.Collections.Generic.List[String]]::new()
                foreach ($prop in $properties) {
                    try {
                        $tempContentList.Add("$($prop.content)")
                    } catch {
                        Write-Warning "Failed to add value for $($property.name) list"
                        continue
                    }
                    try {
                        $tempRawValueList.Add("$($prop.rawValue)")
                    } catch {
                        Write-Warning "Failed to add rawValue for $($property.name) list"
                        continue
                    }
                }
                try {
                    $tempHash.Add($property.name,$tempContentList)
                    $tempHash.Add("$($property.name)_rawValue",$tempRawValueList)
                } catch {
                    throw $_
                }
            }
        }
        try {
            $returnObject = [pscustomobject]$tempHash
        } catch {
            throw $_
        }
        try {
            $type = 'DefaultDisplayPropertySet'
            [Management.Automation.PSMemberInfo[]]$info = New-Object System.Management.Automation.PSPropertySet($type,$visible)
            Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $info -InputObject $returnObject
        } catch {
            throw $_
        }
        $returnObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}