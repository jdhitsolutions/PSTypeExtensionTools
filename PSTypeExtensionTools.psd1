#
# Module manifest for module 'PSTypeExtensionTools'
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PSTypeExtensionTools.psm1'

# Version number of this module.
ModuleVersion = '1.9.0'

# Supported PSEditions
CompatiblePSEditions = @("Desktop","Core")

# ID used to uniquely identify this module
GUID = 'f509035e-cb36-4d2f-b2c8-f4a60fb06d56'

# Author of this module
Author = 'Jeff Hicks'

# Company or vendor of this module
CompanyName = 'JDH Information Technology Solutions, Inc.'

# Copyright statement for this module
Copyright = '(c) 2017-2021 JDH Information Technology Solutions, Inc.'

# Description of the functionality provided by this module
Description = 'A set of PowerShell tools for working with type extensions.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'formats\PSTypeExtension.format.ps1xml'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-PSTypeExtension', 'Get-PSType','Import-PSTypeExtension','Export-PSTypeExtension','Add-PSTypeExtension','New-PSPropertySet'

# Variables to export from this module
VariablesToExport = 'PSTypeSamples'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @('Set-PSTypeExtension')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
         Tags = @('typeextension','typedata')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools/blob/master/License.txt'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/jdhitsolutions/PSTypeExtensionTools'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        #ReleaseNotes = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

