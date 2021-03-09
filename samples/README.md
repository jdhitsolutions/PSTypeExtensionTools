# PSTypeExtension Samples

These files are intended to be used with [Import-PSTypeExtension](../docs/Import-PSTypeExtension.md). Save the file locally and run the import command. You must specify the full file name with file extension, so the function knows how to import the data. Importing *will* overwrite any existing type members with the same name. The new type members will only last for the duration of your PowerShell session. If you always want a set of type extensions, put the `Import-PSTypeExtension` command into your PowerShell profile script.

```powershell
Get-ChildItem c:\scripts\myextensions\*.json | Import-PSTypeExtension
```

Import ps1xml files into your session using `Update-TypeData`. You may see error messages about existing type extensions. When importing a .ps1xml file there don't not appear to be a way to force overwriting existing extensions. But any new extensions will be loaded into your session.
