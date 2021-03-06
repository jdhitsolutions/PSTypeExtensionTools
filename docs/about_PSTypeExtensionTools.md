# PSTypeExtensionTools

## about_PSTypeExtensionTools

## SHORT DESCRIPTION

This PowerShell module contains commands that make it easier to work with type
extensions. Many of these commands are wrappers for built-in tools like
`Get-TypeData` or `Update-TypeData`. The commands in this module simplify the
process of finding, creating, exporting, and importing type extensions.

## LONG DESCRIPTION

Let's say you want to update a number object, but you have no idea what the
type name is. Once you have read help for the commands in this module you
could run a PowerShell command like this:

```powershell
PS C:\> 123 | Get-PSType |
Add-PSTypeExtension -MemberType ScriptProperty -MemberName SquareRoot `
-Value { [math]::Sqrt($this)}
```

Use `$this` to reference the object instead of $_.  Now you can get the new property.

```powershell
PS C:\> $x = 123
PS C:\> $x.SquareRoot
11.0905365064094
```

Once you know the type name you can add other type extensions.

```powershell
Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Squared -value { $this*$this}
Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Cubed -value { [math]::Pow($this,3)}
Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Value -value { $this}
Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptMethod -MemberName GetPercent -value {Param([int32]$Total,[int32]$Round=2) [math]::Round(($this/$total)*100,$round)}
```

Here's how it might look:

```powershell
PS C:\> $x = 38
PS C:\> $x | select *

      SquareRoot Squared Cubed Value
      ---------- ------- ----- -----
6.16441400296898    1444 54872    38

PS C:\> $x.GetPercent(50)
76
PS C:\> $x.GetPercent(100)
38
PS C:\> $x.GetPercent(110,4)
34.5455
```

To see what has been defined, you can use `Get-PSTypeExtension`. You can choose to see all extensions or selected ones by member name.

```powershell
PS C:\> Get-PSTypeExtension system.int32

TypeName: System.Int32

Name       Type           Value
----       ----           -----
SquareRoot ScriptProperty  [math]::Sqrt($this)
Squared    ScriptProperty  $this*$this
Cubed      ScriptProperty  [math]::Pow($this,3)
Value      ScriptProperty  $this
GetPercent ScriptMethod    Param([int32]$Total,[int32]$Round=2) [math]::Round(($this/$total)*100,$round)
```

If you always want these extensions, you would have to put the commands into your PowerShell profile script. Or you can export the extensions to a JSON or XML file. You can either export all members or selected ones which is helpful if you are extending a type that already has type extensions from PowerShell.

```powershell
PS C:\> Get-PSTypeExtension system.int32 -all | Export-PSTypeExtension -TypeName system.int32 -Path c:\work\int32-types.json
```

In your PowerShell profile script, you can then re-import the type extension definitions.

```powershell
Import-PSTypeExtension -Path C:\work\int32-types.json
```

You can also import a directory of type extensions with a single command.

```powershell
dir c:\scripts\mytypes | Import-PSTypeExtension
```

A number of sample files with type extensions can be found in this modules Samples folder or in the GitHub repository at https://github.com/jdhitsolutions/PSTypeExtensionTools/tree/master/samples.  When you have imported the module you can access the samples folder using the $PSTypeSamples variable.

```powershell
Import-PSTypeExtension $PSTypeSamples\measure-extensions.json
```

### Creating ps1xml Files

The `Export-PSTypeExtension` command will also export extensions to a properly formatted .ps1xml file. This can be useful when building type extension files for a module where you want to use the traditional ps1xml form. You can also import these types of files with Update-TypeData with the -AppendPath or -PrependPath parameters.

## NOTE

PowerShell type extensions only last for the duration of your PowerShell session. If you make a mistake that is causing problems, restart PowerShell or use the `Remove-TypeData` cmdlet.

## TROUBLESHOOTING NOTE

Don't try to append or manually update an export file. If you have changes, re-run the export command and generate the file anew.

Remember to use `$this` to reference the object and NOT `$_`.

Remember to enclose scriptblocks in {}.

## SEE ALSO

+ [Add-PSTypeExtension](Add-PSTypeExtension.md)
+ [Export-PSTypeExtension](Export-PSTypeExtension.md)
+ [Get-PSType](Get-PSType.md)
+ [Get-PSTypeExtension](Get-PSTypeExtension.md)
+ [Import-PSTypeExtension](Import-PSTypeExtension.md)
+ [Update-TypeData](Update-TypeData.md)
+ [New-PSPropertySet](New-PSPropertySet.md)

This project was first described at http://jdhitsolutions.com/blog/powershell/5777/a-powershell-module-for-your-type-extensions

## KEYWORDS

- typedata

- typeextension

- propertyset
