<#
.SYNOPSIS
Converts files from a encoding to another encoding.

.DESCRIPTION
The Convert-FileEncoding cmdlet converts files from a encoding to another encoding.

.PARAMETER Path
Specifies the path to an item where Convert-FileEncoding gets the content. Wildcard characters are permitted. The paths must be paths to items, not to containers. For example, you must specify a path to one or more files, not a path to a directory.

.PARAMETER LiteralPath
Specifies a path to one or more locations. The value of LiteralPath is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

.PARAMETER Detected
Get source encodings from Get-FileEncoding.

.PARAMETER SourceEncoding
Specifies the type of encoding for the target file.

.PARAMETER NewEncoding
Specifies the type of encoding for the output file.

.PARAMETER NewFile
Create a new file with file name "filename-NewEncodingName"

.PARAMETER OutputWithBom
Write utf-8 with bom.

.INPUTS
System.String[], UtfUnknown.DetectionDetail[], System.String

.OUTPUTS


.EXAMPLE
Convert-FileEncoding 1.txt -SourceEncoding "utf-8" -NewEncoding "utf-16"

.EXAMPLE
Convert-FileEncoding 1.txt -SourceEncoding "utf-8" -NewEncoding "utf-16"

.NOTES
To find code page name, please visit https://docs.microsoft.com/en-us/dotnet/api/system.text.encoding .
#>
function Convert-FileEncoding {
    [CmdletBinding(DefaultParameterSetName = "DetectedItems")]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "Items",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "DetectedItems",
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "LiteralItems",
            ValueFromPipelineByPropertyName = $true)]
        [Alias("PSPath")]
        [Alias("LP")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $LiteralPath,
        [Parameter(Mandatory = $true,
            ParameterSetName = "DetectedItems",
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [UtfUnknown.DetectionDetail[]]
        $Detected,
        [Parameter(Mandatory = $true,
            ParameterSetName = "LiteralItems")]
        [Parameter(Mandatory = $true,
            ParameterSetName = "Items")]
        [string]
        $SourceEncoding,
        [Parameter(Mandatory = $true)]
        [string]
        $NewEncoding,
        [Parameter(Mandatory = $false)]
        [switch]
        $NewFile,
        [Parameter(Mandatory = $false)]
        [switch]
        $OutputWithBom
    )
    process {
        $se = $null;
        if (-not [string]::IsNullOrWhiteSpace($SourceEncoding)) {
            try {
                $se = [System.Text.Encoding]::GetEncoding($SourceEncoding);
            }
            catch {
                Write-Error -Exception $_.Exception;
                return;
            }
        }
        $ne = $null;
        if (-not [string]::IsNullOrWhiteSpace($NewEncoding)) {
            try {
                if (($NewEncoding -match "65001") -or ($NewEncoding -match "utf-8") -and $OutputWithBom) {
                    $ne = [System.Text.UTF8Encoding]::new($true);
                }
                else {
                    $ne = [System.Text.Encoding]::GetEncoding($NewEncoding);
                }
            }
            catch {
                Write-Error -Exception $_.Exception;
                return;
            }
        }
        else {
            $ne = [System.Text.Encoding]::UTF8;
        }
        if ($Detected.Count -gt 0) {
            for ($i = 0; $i -lt $Detected.Count; $i++) {
                $newName = $Path[$i];
                if ($NewFile) {
                    $newName = [System.IO.Path]::GetFileNameWithoutExtension($Path[$i]) + "-" + $ne.WebName + [System.IO.Path]::GetExtension($Path[0]);
                }
                $text = [System.IO.File]::ReadAllText($newName, $Detected[$i].Encoding);
                [System.IO.File]::WriteAllText($newName, $text, $ne);
            }
        }
        else {
            $files = $null
            try {
                if ($Path.Count -ge 1) {
                    $files = Get-ChildItem -Path $Path -ErrorAction Stop
                }
                else {
                    $files = Get-ChildItem -LiteralPath $LiteralPath -ErrorAction Stop
                }
            }
            catch {
                Write-Error -Exception $_.Exception;
                return;
            }
            foreach ($file in $files) {
                $newName = $file.FullName;
                if ($NewFile) {
                    $newName = $file.Directory.FullName + [System.IO.Path]::DirectorySeparatorChar + $file.Name + "-" + $ne.WebName + $file.Extension;
                }
                $text = [System.IO.File]::ReadAllText($newName, $se);
                [System.IO.File]::WriteAllText($newName, $text, $ne);
            }
        }
    }
}