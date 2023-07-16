function Convert-GetItemsResponse {
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
        #foreach ($item in $Response.Envelope.Body.GetItemsResponse.Items.GetEnumerator()) {
            . 'C:\Users\anth\GitHub\easitanth\Easit.GO.Webservice\source\private\Convert-AttachmentElement.ps1'
            . 'C:\Users\anth\GitHub\easitanth\Easit.GO.Webservice\source\private\Convert-PropertyElement.ps1'
            . 'C:\Users\anth\GitHub\easitanth\Easit.GO.Webservice\source\private\New-ReturnObject.ps1'
            . 'C:\Users\anth\GitHub\easitanth\Easit.GO.Webservice\source\private\Add-PropertyFromColumn.ps1'
            . 'C:\Users\anth\GitHub\easitanth\Easit.GO.Webservice\source\private\Add-PropertyFromItemChildElement.ps1'
            $xmlResponse = $using:Response
            #$xmlResponse = $Response
            if ($xmlResponse.Envelope.Body.GetItemsResponse.totalNumberOfItems -lt 1) {
                Write-Warning "View did not return any Easit GO objects"
                return
            }
            # Set up for creating a new object from an XML item
            try {
                $returnObject = New-ReturnObject -XML $xmlResponse -Verbose
            } catch {
                throw $_
            }
            # We use the column details to build out a PSCustomObject base
            try {
                $returnObject = Add-PropertyFromColumn -XML $xmlResponse -InputObject $returnObject -Verbose
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
                    $returnObject = Set-PropertyValueFromItemChildElement -ChildElement $itemProperty -InputObject $returnObject -Verbose
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