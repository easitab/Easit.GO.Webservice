function Write-StringToFile {
    <#
    .SYNOPSIS
        Sends a string to a file.
    .DESCRIPTION
        The **Write-StringToFile** function sends a string to a file. If the file already exists a new file with a higher index number (following the naming format \[FilenamePrefix\]_payload_indexNumber.txt) will be created.
    .EXAMPLE
        Write-StringToFile -InputString $baseRMParams.Body -FilenamePrefix 'GetEasitGOItem'
    .EXAMPLE
        Write-StringToFile -InputString $baseRMParams.Body -FilenamePrefix 'SendToEasitGO'
    .PARAMETER InputString
        String to write to a file.
    .PARAMETER FilenamePrefix
        Prefix to set prepend to *_payload_indexNumber.txt*. If not prefix is provided, file name will be *payload_indexNumber.txt*.
    .OUTPUTS
        None - This function returns no output.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$InputString,
        [Parameter()]
        [String]$FilenamePrefix
    )
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    process {
        $i = 1
        $currentDirectory = Get-Location
        if ([String]::IsNullOrWhiteSpace($FilenamePrefix)) {
            $baseFilename = 'payload'
        } else {
            $baseFilename = "${FilenamePrefix}_payload"
        }
        do {
            $outputFileName = "${baseFilename}_$i.txt"
            $payloadFile = Join-Path -Path $currentDirectory -ChildPath "$outputFileName"
            if (Test-Path $payloadFile) {
                    $i++
            }
        } until (!(Test-Path $payloadFile))
        if (!(Test-Path $payloadFile)) {
            try {
                $outFileParams = @{
                    FilePath = "$payloadFile"
                    Encoding = 'utf8NoBOM'
                    Force = $true
                }
                $InputString | Out-File @outFileParams
            }
            catch {
                throw $_
            }
        }
    }
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}