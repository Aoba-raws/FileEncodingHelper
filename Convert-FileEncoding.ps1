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
        $OutputWithBom,
        [Parameter(Mandatory = $false,
            ParameterSetName = "LiteralItems")]
        [switch]
        $UseDetected
    )

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