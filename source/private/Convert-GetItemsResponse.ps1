function Convert-GetItemsResponse {
    <#
    .SYNOPSIS
        Function for converting items in a GetItems XML response (GetItemsResponse) to PSCustomObject.
    .DESCRIPTION
        **Convert-GetItemsResponse** converts each item in *GetItemsResponse.Items* to a PSCustomObject.
        Each PSCustomObject gets its properties from GetItemsResponse.Columns.
        Each PSCustomObject has a "hidden" property ([propertyName_details]) for each property from GetItemsResponse.Columns.
    .EXAMPLE
        $response = Invoke-EasitWebRequest -url $url -api $api -body $body
        Convert-GetItemsResponse -Response $reponse
    .PARAMETER Response
        XML response to convert
    .PARAMETER ThrottleLimit
        Specifies the number of script blocks that run in parallel. Input objects are blocked until the running script block count falls below the ThrottleLimit.
    .OUTPUTS
        [PSCustomObject](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.pscustomobject)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [xml]$Response,
        [Parameter()]
        [int]$ThrottleLimit
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator() | ForEach-Object -Parallel {
            $xmlResponse = $using:Response
            if ($xmlResponse.Envelope.Body.GetItemsResponse.totalNumberOfItems -lt 1) {
                Write-Warning "View did not return any Easit GO objects"
                return
            }
            # Set up for creating a new object from an XML item
            try {
                $returnObject = New-ReturnObject -XML $xmlResponse
            } catch {
                throw $_
            }
            # We use the column details to build out a PSCustomObject base
            try {
                $returnObject = Add-PropertyFromColumn -XML $xmlResponse -InputObject $returnObject
            } catch {
                throw $_
            }
            foreach ($column in $xmlResponse.Envelope.Body.GetItemsResponse.Columns.GetEnumerator()) {
                if (!($visible -contains $column.InnerText)) {
                    [string[]]$visible += $column.InnerText
                }
            }
            # Here we add each property value to the corresponding column property
            foreach ($itemProperty in $_.GetEnumerator()) {
                if ($itemProperty.LocalName -eq 'Attachment') {
                    if (!($visible -contains 'Attachments')) {
                        [string[]]$visible += 'Attachments'
                    }
                }
                try {
                    $returnObject = Set-PropertyValueFromItemChildElement -ChildElement $itemProperty -InputObject $returnObject
                } catch {
                    throw $_
                }
            }
            try {
                $type = 'DefaultDisplayPropertySet'
                [Management.Automation.PSMemberInfo[]]$info = New-Object System.Management.Automation.PSPropertySet($type,$visible)
                Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $info -InputObject $returnObject
            } catch {
                throw $_
            }
            $returnObject
        } -ThrottleLimit $ThrottleLimit
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}