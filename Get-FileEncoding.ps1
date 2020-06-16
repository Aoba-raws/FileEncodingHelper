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