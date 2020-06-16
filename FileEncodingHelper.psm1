. $PSScriptRoot\FileEncodingOutput.ps1
. $PSScriptRoot\Get-FileEncoding.ps1
Add-Type -Path "$PSScriptRoot\UtfUnknown.dll"

$exportModuleMemberParams = @{
    Alias = @('gfe')
    Function = @(
        'Get-FileEncoding'
    )
}

Export-ModuleMember @exportModuleMemberParams