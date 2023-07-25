function Add-PropertyFromColumn {
    <#
    .SYNOPSIS
        Adds each column in GetItemsResponse.Columns as properties to a PSCustomObject.
    .DESCRIPTION
        The **Add-PropertyFromColumn** functions adds all column elements from a GetItemsResponse XML object to a PSCustomObject as properties
        with the innerText as the property name.
        If the element attribute *collection* is true or if the innerText value occurre multiple times the property will be treated as an array.

        For each column element a [propertyName]_details property is also added containing details about the value such as *datatype*, *connectiontype*,
        *IsArray* and *IsCollection*.
    .EXAMPLE
        $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator() | ForEach-Object -Parallel {
            $xmlResponse = $using:Response
            try {
                $returnObject = New-ReturnObject -XML $xmlResponse
                $returnObject = Add-PropertyFromColumn -XML $xmlResponse -InputObject $returnObject
            } catch {
                throw $_
            }
        }
    .PARAMETER XML
        XML reponse object to add properties from.
    .PARAMETER InputObject
        Object to add properties to.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [XML]$XML,
        [Parameter(Mandatory)]
        [PSCustomObject]$InputObject
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        foreach ($column in $XML.Envelope.Body.GetItemsResponse.Columns.GetEnumerator()) {
            $columnName = $column.InnerText
            $columnDetails = [PSCustomObject]@{
                Name = $column.InnerText
                DataType = $column.datatype
                ConnectionType = $column.connectiontype
                IsArray = $false
            }
            if ($column.collection -eq 'true') {
                $columnDetails | Add-Member -MemberType NoteProperty -Name 'IsCollection' -Value $true
            } else {
                $columnDetails | Add-Member -MemberType NoteProperty -Name 'IsCollection' -Value $false
            }
            try {
                $columnOccurrences = ($XML.Envelope.Body.GetItemsResponse.Columns.GetEnumerator() | Where-Object -Property 'InnerText' -EQ -Value $column.InnerText).Count
                Write-Debug "$($column.InnerText) occurres $columnOccurrences times"
            } catch {
                throw $_
            }
            if ($columnOccurrences -gt 1) {
                $columnDetails.IsArray = $true
            }
            if (Get-Member -InputObject $InputObject -Name "${columnName}_details") {
                try {
                    $InputObject."${columnName}_details".Add($columnDetails)
                } catch {
                    throw $_
                }
            }
            if (!(Get-Member -InputObject $InputObject -Name $columnDetails.Name)) {
                try {
                    $InputObject | Add-Member -MemberType NoteProperty -Name $columnDetails.Name -Value $null
                } catch {
                    throw $_
                }
                if ($columnDetails.IsCollection) {
                    try {
                        $InputObject."$columnName" = ([System.Collections.Generic.List[String]]::new())
                        $InputObject | Add-Member -MemberType NoteProperty -Name "${columnName}_details" -Value ([System.Collections.Generic.List[PSCustomObject]]::new())
                    } catch {
                        throw $_
                    }
                }
                if ($columnOccurrences -gt 1) {
                    try {
                        $InputObject."$columnName" = ([System.Collections.Generic.List[String]]::new())
                        $InputObject | Add-Member -MemberType NoteProperty -Name "${columnName}_details" -Value ([System.Collections.Generic.List[PSCustomObject]]::new())
                    } catch {
                        throw $_
                    }
                }
                if ($columnDetails.IsCollection -eq $false -AND $columnOccurrences -le 1) {
                    try {
                        $InputObject | Add-Member -MemberType NoteProperty -Name "${columnName}_details" -Value $columnDetails
                    } catch {
                        throw $_
                    }
                }
            }
        }
        $InputObject
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}