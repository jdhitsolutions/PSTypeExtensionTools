#
# Module manifest for PSTypeExtensionTools
#

@{
    RootModule           = 'PSTypeExtensionTools.psm1'
    ModuleVersion        = '1.11.0'
    CompatiblePSEditions = @("Desktop", "Core")
    GUID                 = 'f509035e-cb36-4d2f-b2c8-f4a60fb06d56'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2017-2025 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell tools for working with custom type extensions.'
    PowerShellVersion    = '5.1'
    FormatsToProcess     = @(
        'formats\PSTypeExtension.format.ps1xml',
        'formats\PSTypeExtensionPreview.format.ps1xml',
        'formats\PSTypeUpdatePreview.format.ps1xml'
    )
    FunctionsToExport    = @(
        'Add-PSTypeExtension',
        'Export-PSTypeExtension',
        'Get-PSType',
        'Get-PSTypeDataPreview'
        'Get-PSTypeExtension',
        'Import-PSTypeExtension',
        'New-PSPropertySet'
        )
    VariablesToExport    = 'PSTypeSamples'
    AliasesToExport      = @('Set-PSTypeExtension','gtex','itex','atex','etex')
    PrivateData          = @{
        PSData = @{
            Tags       = @('TypeExtension', 'TypeData')
            LicenseUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools/blob/master/License.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
    DefaultCommandPrefix = ''
}
