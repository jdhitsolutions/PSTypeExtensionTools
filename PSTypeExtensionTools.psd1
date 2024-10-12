#
# Module manifest for PSTypeExtensionTools
#

@{
    RootModule           = 'PSTypeExtensionTools.psm1'
    ModuleVersion        = '1.10.1'
    CompatiblePSEditions = @("Desktop", "Core")
    GUID                 = 'f509035e-cb36-4d2f-b2c8-f4a60fb06d56'
    Author               = 'Jeff Hicks'
    CompanyName          = 'JDH Information Technology Solutions, Inc.'
    Copyright            = '(c) 2017-2024 JDH Information Technology Solutions, Inc.'
    Description          = 'A set of PowerShell tools for working with custom type extensions.'
    PowerShellVersion    = '5.1'
    FormatsToProcess     = 'formats\PSTypeExtension.format.ps1xml'
    FunctionsToExport    = 'Get-PSTypeExtension', 'Get-PSType', 'Import-PSTypeExtension', 'Export-PSTypeExtension', 'Add-PSTypeExtension', 'New-PSPropertySet'
    VariablesToExport    = 'PSTypeSamples'
    AliasesToExport      = @('Set-PSTypeExtension')
    PrivateData          = @{
        PSData = @{
            Tags       = @('typeextension', 'TypeData')
            LicenseUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools/blob/master/License.txt'
            ProjectUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools'
        } # End of PSData hashtable
    } # End of PrivateData hashtable
    DefaultCommandPrefix = ''
}
