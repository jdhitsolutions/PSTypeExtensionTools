# Change Log for PSTypeExtensionTools

## [Unreleased]

## [1.11.0] - 2025-06-25

### Added

- Added argument completer for the `TypeName` parameter in `Get-PSTypeExtension`.
- Added alias `gtex` for `Get-PSTypeExtension`.
- Added alias `itex` for `Import-PSTypeExtension`.
- Added alias `atex` for `Add-PSTypeExtension`.
- Added alias `etex` for `Export-PSTypeExtension`.
- Added command `Get-PSTypeDataPreview` and custom formatting file to preview type extension settings in .ps1xml files.
- Added a `Preview` parameter to `Import-PSTypeExtension` so the user can preview the new type extensions.

### Changed

- Migrated to the new changelog format.
- Standardize Verbose message formatting.
- Updated online help links.
- Update `README.md`.
- Updated the `about` help topic file.
- Command help updates.

### Fixed

- Fixed typo on `Export-PSTypeExtension`.

## [v1.10.1] - 2024-10-12

- Removed default command prefix in the module manifest, accidentally left in from a demonstration.

## [v1.10.0] - 2024-10-11

- Code cleanup and re-formatting.
- Help updates.
- Updated `README.md`.

## [v1.9.0] - 2021-08-10

- Fixed bug in `New-PSPropertySet` that failed to recognize a custom type. ([Issue #21](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/21))
- Re-organized module layout.
- Help updates.
- Updated `README.md`.

## [v1.8.0] - 2021-03-10

- Fixed bugs in `Get-PSTypeExtension` and `Export-PSTypeExtension` where I needed to let the user force recognizing a type name. ([Issue #20](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/20))
- Help updates.
- Updated `README.md`.

## [v1.7.1] - 2021-03-09

- Fixed bug in `New-PSPropertySet` that failed to correct typename case. ([Issue #19](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/19))
- Updated online help link for `New-PSPropertySet`.
- Added sample file `process.types.ps1xml`.
- Updated `README.md`.

## [v1.7.0] - 2021-03-09

- Added `services.types.ps1xml` to samples folder.
- Updated `README.md`.
- Updates `README.md` in Samples folder.
- Changed statements using `Out-Null` to use `[void]`.
- Modified `Export-PSTypeExtension` to support appending in a very specific use-case. ([Issue #16](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/16))
- Added a private function, `_convertTypeName` to convert typename values to properly cased names.
- Modified `Export-PSTypeExtension` to add a `-Passthru` parameter. ([Issue #18](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/18))
- Updated help.

## [v1.6.0] - 2021-03-08

- Re-organized module structure.
- Added command `New-PSPropertySet`to create a ps1xml file that defines a custom property set. ([Issue #15](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/15))
- Modified `Get-PSTypeExtension` to hide `CodeProperty` values by defaults. ([Issue #17](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/1))
- Modified `Get-PSTypeExtension` to display results sorted by member type and name.

## [v1.5.1] - 2020-02-29

- Fixed error in exporting aliases.
- Updated license file.
- Very minor help corrections.

## [v1.5.0] - 2019-09-21

- Added new parameter, `-IncludeDeserialized`, on `Add-PSTypeExtension` ([Issue #14](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/14))
- Modified `Import-PSTypeExtension` to allow piping files into the command.
- Added alias `Type` to `-MemberType` parameter of `Add-PSTypeExtension`
- Added alias `Name` to `-MemberName` parameter of `Add-PSTypeExtension`
- Added online help links.
- Updated some of the sample JSON files to include deserialized type versions.
- Updated help documentation.
- Updated `README.md`.

## [v1.4.0] - 2019-02-18

- Modified manifest to require PowerShell 5.1.
- Modified manifest to support both Desktop and Core PSEditions.
- Updates to some of the sample files.
- Updated `README.md`.

## [v1.3.0] - 2018-10-23

- File cleanup for the PowerShell Gallery.
- Exported Samples folder as a variable to make it easier to import.
- code cleanup
- markdown cleanup
- help cleanup
- Updates to `README.md`

## [v1.1.0] - 2018-09-28

- Fixed `Import-PSTypeExtension` bug piping in json/xml files ([Issue #13](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/13))
- Updated About help documentation
- Modified pipeline processing in `Get-PSTypeExtension` ([Issue #12](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/12))

## [v1.0.0] - 2017-12-15

- Modified `Export-PSTypeExtension` to export to a ps1xml file ([Issue #11](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/11))
- release to the PowerShell Gallery
- Updated documentation
- Updated samples

## v0.5.1 - 2017-11-21

- fixed bug in the CimInstance json sample
- fixed link bug in README.md file

## v0.5.0 - 2017-11-14

- Modified `Get-PSType` to better reflect type names. ([Issue #7](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/7))
- added additional sample files.
- modified `Get-PSTypeExtension` to include PSTypeExtension as a typename
- added format ps1xml (Issue #8)
- revised parameter validation for `Get-PSTypeExtension` ([Issue #10](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/10))
- revised `Import-PSTypeExtension` to accept pipelined input for filenames ([Issue #9](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/9))
- updated documentation

## v0.4.0 - 2017-11-13

- Modified `Get-PSTypeExtension` so -All is the default ([Issue #6](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/6))
- Modified `Get-PSTypeExtension` to validate typename
- Updated help documentation to include an About file
- Reverted Changelog to a text file
- Updated Strings sample file.

## v0.3.0 - 2017-11-11

- fixed bug in `Get-PSTypeExtension` that was writing a blank object to the pipeline. ([Issue #3](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/3))
- Added support for WhatIf to `Export-PSTypeExtension` ([Issue #2](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/2))
- documentation update

## v0.2.0 - 2017-11-10

- renamed commands to be consistent with the module name
- updated help documentation
- Added `Set-PSTypeExtension` as an alias to `Add-PSTypeExtension`

## v0.1.0 - 2017-11-10

- major changes to functions and design
- Added `Get-PSType` function
- Added `Get-MyTypeExtension` function
- Added `Get-MyTypeExtension` function

## v0.0.4 - 2017-11-09

- Updated to handle other member type ([Issue #2](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/2))

## v0.0.3 - 2017-10-31

- added ShouldSupportProcess for `Import-MyTypeExtension` ([Issue #1](https://github.com/jdhitsolutions/PSTypeExtensionTools/issues/1)
- updated help
- updated manifest

## v0.0.2 - 2017-10-31

- added a manifest

## v0.0.1 - 2017-10-31

- Initial module

[Unreleased]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.11.0..HEAD
[1.11.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/vv1.10.1..v1.11.0
[v1.10.1]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.10.0..v1.10.1
[v1.10.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.9.0..v1.10.0
[v1.9.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.8.0..v1.9.0
[v1.8.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.7.1..v1.8.0
[v1.7.1]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.7.0..v1.7.1
[v1.7.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.6.0..v1.7.0
[v1.6.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.5.1..v1.6.0
[v1.5.1]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.5.0..v1.5.1
[v1.5.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.4.0..v1.5.0
[v1.4.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.3.0..v1.4.0
[v1.3.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.1.0..v1.3.0
[v1.1.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v1.0.0..v1.1.0
[v1.0.0]: https://github.com/jdhitsolutions/PSTypeExtensionTools/compare/v0.5.1-beta..v1.0.0