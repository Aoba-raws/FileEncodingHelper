@{
    # If authoring a script module, the RootModule is the name of your .psm1 file
    RootModule = 'FileEncodingHelper.psm1'

    Author = 'Aoba xu <aobaxu@gmail.com>'

    CompanyName = 'Aoba-Raws'

    ModuleVersion = '1.0'

    # Use the New-Guid command to generate a GUID, and copy/paste into the next line
    GUID = 'e9271847-e28b-41d1-a409-b40c0337f4a2'

    Copyright = '2020 Copyright Aoba-Raws'

    Description = 'A Powershell module which can detected encoding automatically. And can transcode file to other encoding.'

    # Minimum PowerShell version supported by this module (optional, recommended)
    PowerShellVersion = '5.1'

    # Which PowerShell Editions does this module work with? (Core, Desktop)
    CompatiblePSEditions = @('Desktop', 'Core')

    # Which PowerShell functions are exported from your module? (eg. Get-CoolObject)
    FunctionsToExport = @('Get-FileEncoding')

    # Which PowerShell aliases are exported from your module? (eg. gco)
    AliasesToExport = @('')

    # Which PowerShell variables are exported from your module? (eg. Fruits, Vegetables)
    VariablesToExport = @('')

    # PowerShell Gallery: Define your module's metadata
    PrivateData = @{
        PSData = @{
            # What keywords represent your PowerShell module? (eg. cloud, tools, framework, vendor)
            Tags = @('encoding', 'transcode')

            # What software license is your code being released under? (see https://opensource.org/licenses)
            LicenseUri = 'https://github.com/Aoba-raws/FileEncodingHelper/blob/master/LICENSE'

            # What is the URL to your project's website?
            ProjectUri = 'https://github.com/Aoba-raws/FileEncodingHelper'

            # What is the URI to a custom icon file for your project? (optional)
            IconUri = ''

            # What new features, bug fixes, or deprecated features, are part of this release?
            ReleaseNotes = @'
'@
        }
    }

    # If your module supports updateable help, what is the URI to the help archive? (optional)
    # HelpInfoURI = ''
}