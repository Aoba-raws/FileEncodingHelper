<#
.SYNOPSIS
Get the encoding of the item at the specified location.

.DESCRIPTION
The Get-FileEncoding cmdlet gets the encoding of the item at the location specified by the path. It use Ude(universalchardet) to detect encoding.

.PARAMETER Path
Specifies the path to an item where Get-FileEncoding gets the content. Wildcard characters are permitted. The paths must be paths to items, not to containers. For example, you must specify a path to one or more files, not a path to a directory.

.PARAMETER LiteralPath
Specifies a path to one or more locations. The value of LiteralPath is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell PowerShell not to interpret any characters as escape sequences.

.INPUTS
System.String[]

.OUTPUTS
FileEncodingOutput[]

.EXAMPLE
Get-FileEncoding 1.txt

.EXAMPLE
Get-FileEncoding -LiteralPath "2[1].txt"

.EXAMPLE
Get-FileEncoding "*.txt"

.NOTES
To read more about Ude please open https://mxr.mozilla.org/mozilla/source/extensions/universalchardet/ .
#>
function Get-FileEncoding {
    [CmdletBinding(DefaultParameterSetName="Items")]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "Items",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Path to one or more locations.")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "LiteralItems",
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Literal path to one or more locations.")]
        [Alias("PSPath")]
        [Alias("LP")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $LiteralPath
    )
    process {
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
        foreach ($item in $files) {
            $result = [UtfUnknown.CharsetDetector]::DetectFromFile($item);
            [FileEncodingOutput]::new($item.FullName, $result);
        }
    }
}