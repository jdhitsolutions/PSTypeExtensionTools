# Change Log for PSTypeExtensionTools

## v1.10.0

- Code cleanup and re-formatting.
- Help updates.
- Updated `README.md`.

## v1.9.0

- Fixed bug in `New-PSPropertySet` that failed to recognize a custom type. ([Issue #21](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/21))
- Re-organized module layout.
- Help updates.
- Updated `README.md`.

## v1.8.0

- Fixed bugs in `Get-PSTypeExtension` and `Export-PSTypeExtension` where I needed to let the user force recognizing a type name. ([Issue #20](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/20))
- Help updates.
- Updated `README.md`.

## v1.7.1

- Fixed bug in `New-PSPropertySet` that failed to correct typename case. ([Issue #19](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/19))
- Updated online help link for `New-PSPropertySet`.
- Added sample file `process.types.ps1xml`.
- Updated `README.md`.

## v1.7.0

- Added `services.types.ps1xml` to samples folder.
- Updated `README.md`.
- Updates `README.md` in Samples folder.
- Changed statements using `Out-Null` to use `[void]`.
- Modified `Export-PSTypeExtension` to support appending in a very specific use-case. ([Issue #16](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/16))
- Added a private function, `_convertTypeName` to convert typename values to properly cased names.
- Modified `Export-PSTypeExtension` to add a `-Passthru` parameter. ([Issue #18](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/18))
- Updated help.

## v1.6.0

- Re-organized module structure.
- Added command `New-PSPropertySet`to create a ps1xml file that defines a custom property set. ([Issue #15](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/15))
- Modified `Get-PSTypeExtension` to hide `CodeProperty` values by defaults. ([Issue #17](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/1))
- Modified `Get-PSTypeExtension` to display results sorted by member type and name.

## v1.5.1

- Fixed error in exporting aliases.
- Updated license file.
- Very minor help corrections.

## v1.5.0

- Added new parameter, `-IncludeDeserialized`, on `Add-PSTypeExtension` ([Issue #14](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/14))
- Modified `Import-PSTypeExtension` to allow piping files into the command.
- Added alias `Type` to `-MemberType` parameter of `Add-PSTypeExtension`
- Added alias `Name` to `-MemberName` parameter of `Add-PSTypeExtension`
- Added online help links.
- Updated some of the sample JSON files to include deserialized type versions.
- Updated help documentation.
- Updated `README.md`.

## v1.4.0

- Modified manifest to require PowerShell 5.1.
- Modified manifest to support both Desktop and Core PSEditions.
- Updates to some of the sample files.
- Updated `README.md`.

## v1.3.0

- File cleanup for the PowerShell Gallery.
- Exported Samples folder as a variable to make it easier to import.
- code cleanup
- markdown cleanup
- help cleanup
- Updates to `README.md`

## v1.1.0

- Fixed `Import-PSTypeExtension` bug piping in json/xml files ([Issue #13](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/13))
- Updated About help documentation
- Modified pipeline processing in `Get-PSTypeExtension` ([Issue #12](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/12))

## v1.0.0

- Modified `Export-PSTypeExtension` to export to a ps1xml file ([Issue #11](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/11))
- release to the PowerShell Gallery
- Updated documentation
- Updated samples

## v0.5.1

- fixed bug in the CimInstance json sample
- fixed link bug in README.md file

## v0.5.0

- Modified `Get-PSType` to better reflect type names. ([Issue #7](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/7))
- added additional sample files.
- modified `Get-PSTypeExtension` to include PSTypeExtension as a typename
- added format ps1xml (Issue #8)
- revised parameter validation for `Get-PSTypeExtension` ([Issue #10](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/10))
- revised `Import-PSTypeExtension` to accept pipelined input for filenames ([Issue #9](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/9))
- updated documentation

## v0.4.0

- Modified `Get-PSTypeExtension` so -All is the default ([Issue #6](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/6))
- Modified `Get-PSTypeExtension` to validate typename
- Updated help documentation to include an About file
- Reverted Changelog to a text file
- Updated Strings sample file.

## v0.3.0

- fixed bug in `Get-PSTypeExtension` that was writing a blank object to the pipeline. ([Issue #3](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/3))
- Added support for WhatIf to `Export-PSTypeExtension` ([Issue #2](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/2))
- documentation update

## v0.2.0

- renamed commands to be consistent with the module name
- updated help documentation
- Added `Set-PSTypeExtension` as an alias to `Add-PSTypeExtension`

## v0.1.0

- major changes to functions and design
- Added `Get-PSType` function
- Added `Get-MyTypeExtension` function
- Added `Get-MyTypeExtension` function

## v0.0.4

- Updated to handle other member type ([Issue #2](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/2))

## v0.0.3

- added ShouldSupportProcess for `Import-MyTypeExtension` ([Issue #1](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/1)
- updated help
- updated manifest

## v0.0.2

- added a manifest

## v0.0.1

- Initial module
