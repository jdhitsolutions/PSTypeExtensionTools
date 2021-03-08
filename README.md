# PSTypeExtensionTools

[![PSGallery Version](https://img.shields.io/powershellgallery/v/PSTypeExtensionTools.png?style=for-the-badge&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/PSTypeExtensionTools/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/PSTypeExtensionTools.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/PSTypeExtensionTools/)

This PowerShell module contains commands that make it easier to work with type extensions. Many of these commands are wrappers for built-in tools like [Get-TypeData](http://go.microsoft.com/fwlink/?LinkId=821805) or [Update-TypeData](http://go.microsoft.com/fwlink/?LinkId=821871). This module should work in Windows PowerShell and PowerShell 7.x.

## Release

You can install the current release from the PowerShell Gallery:

```powershell
Install-Module PSTypeExtensionTools
```

## Why You Want to Use This

Let's say you want to update a number object, but you have no idea what the type name is. Once you have read help for the commands in this module, you could run a PowerShell command like this:

```powershell
PS C:\> 123 | Get-PSType | Add-PSTypeExtension -MemberType ScriptProperty -MemberName SquareRoot -Value { [math]::Sqrt($this)}
```

Use `$this` to reference the object instead of `$_`.  Now you can get the new property.

```powershell
PS C:\> $x = 123
PS C:\> $x.SquareRoot
11.0905365064094
```

Once you know the type name, you can add other type extensions.

```powershell
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Squared -value { $this*$this}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Cubed -value { [math]::Pow($this,3)}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Value -value { $this}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptMethod -MemberName GetPercent -value {Param([int32]$Total,[int32]$Round=2) [math]::Round(($this/$total)*100,$round)}

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
GetPercent ScriptMethod   Param([int32]$Total,[int32]$Round=2) [math]::Round(($this/$total)*100,$round)
```

If you always want these extensions, you would have to put the commands into your PowerShell profile script. Or you can export the extensions to a JSON or XML file. You can either export all members or selected ones, which is helpful if you are extending a type that already has type extensions from PowerShell.

```powershell
PS C:\> Get-PSTypeExtension system.int32 | Export-PSTypeExtension -TypeName system.int32 -Path c:\work\int32-types.json
```

In your PowerShell profile scrip,t you can then re-import the type extension definitions.

```powershell
Import-PSTypeExtension -Path C:\work\int32-types.json
```

## PSTypeExtensionTools Cmdlets

### [Add-PSTypeExtension](docs/Add-PSTypeExtension.md)

Add a new type extension such as an `Alias` or `ScriptProperty`.

### [Export-PSTypeExtension](docs/Export-PSTypeExtension.md)

Export type extensions to a json, xml or ps1xml file.

### [Get-PSType](docs/Get-PSType.md)

Get the type name of an object.

### [Get-PSTypeExtension](docs/Get-PSTypeExtension.md)

Get type extensions for a given type.

### [Import-PSTypeExtension](docs/Import-PSTypeExtension.md)

Import type extension definitions from a JSON file or XML.

### [New-PSPropertySet](docs/New-PSPropertySet.md)

In addition to custom properties, PowerShell also has the idea of a _propertyset_. This allows you to reference a group of properties with a single name.

Let's say you have loaded the sample fileinfo type extensions from this module.

```powershell
PS C:\> Import-PSTypeExtension -Path $PSTypeSamples\fileinfo-extensions.json
```powershell

You could write a command like this:

```powershell
dir c:\work -file | Select-Object Name,Size,LastWriteTime,Age
```

Or you could create a custom property set. These have to be defined in `ps1xml` files. The `New-PSPropertySet` simplifies this process.

```powershell
 New-PSPropertySet -Typename System.IO.FileInfo -Name FileAge -Properties Name,Size,LastWriteTime,Age -FilePath d:\temp\Fileinfo.types.ps1xml
```

I've included the file in the Samples folder.

```powershell
PS C:\> Update-TypeData $PSTypeSamples\fileinfo.types.ps1xml
PS C:\> dir c:\work -file | Select-Object fileage

Name                          Size    LastWriteTime            Age
----                          ---- -  -----------              ---
a.dat                            42   2/12/2021 5:36:55 PM     23.17:27:21
a.txt                         14346   12/31/2020 9:10:15 AM    67.01:54:00
a.xml                        171394   12/31/2020 12:15:44 PM   66.22:48:32
aa.ps1                        28866   12/31/2020 9:13:16 AM    67.01:51:00
aa.txt                        28866   12/31/2020 9:11:18 AM    67.01:52:58
about.json                    16455   2/27/2021 10:11:03 AM    09.00:53:12
about_ADReportingTools         1688   3/4/2021 7:37:01 PM      03.15:27:14
b.csv                          1273   11/13/2020 12:11:35 PM   114.22:52:40
...
```

If your property set is using custom properties, you need to load them into your PowerShell session before you can use the property set.

## Create ps1xml Files

The export command makes it easy to construct a ps1xml file. All you need to do is provide the type name and the extensions you want to export, and it will create a properly formatted ps1xml file that you can import into a session with `Update-TypeData` or distribute with a module. No more clunky XML copying, pasting, and hoping for the best.

Well, there is one reason you still might need to do some copying and pasting. Technically, you can define all custom properties, including property sets, in a single .ps1xml file. However, I don't have a simple command to export everything for a single type to a single file. For now, you can create a `<typename>.types.ps1xml` file for your custom extensions. Then manually merge the `Members` section from your property set .ps1xml file. This is only necessary if you have custom extensions **and** one or more property sets defined for a given type.

## I Want to Try

You can find a number of type extension exports in the [Samples](./samples) folder. The location will be saved to a global variable, `$PSTypeSamples`. This makes it a bit easier to import.

```powershell
PS C:\> dir $PSTypeSamples


    Directory: C:\scripts\PSTypeExtensionTools\samples


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       12/15/2017   2:25 PM            766 cimlogicaldisk-extensions.json
-a----        9/28/2018   9:48 AM            265 datetime-extensions.json
-a----       12/15/2017   5:09 PM            232 eventlog-type.json
-a----        2/18/2019   1:18 PM           1266 fileinfo-extensions.json
-a----       11/13/2017   8:37 AM            901 int32-types.json
-a----        11/1/2017   6:18 PM            653 measure-extensions.json
-a----       11/13/2017   8:49 AM            890 process-types.xml
-a----       12/15/2017   6:09 PM            628 README.md
-a----       12/15/2017   2:09 PM           1246 stringtypes.json
-a----        11/9/2017  12:08 PM           3024 vm-extensions.json

PS C:\> Import-PSTypeExtension $PSTypeSamples\measure-extensions.json -Verbose
VERBOSE: Starting: Import-PSTypeExtension
VERBOSE: Importing file C:\scripts\PSTypeExtensionTools\samples\measure-extensions.json
VERBOSE: Processing ScriptProperty : SumKB
VERBOSE: Creating scriptblock from value
VERBOSE: Performing the operation "Adding ScriptProperty SumKB" on target "Microsoft.PowerShell.Commands.GenericMeasureInfo".
VERBOSE: Processing ScriptProperty : SumMB
VERBOSE: Creating scriptblock from value
VERBOSE: Performing the operation "Adding ScriptProperty SumMB" on target "Microsoft.PowerShell.Commands.GenericMeasureInfo".
VERBOSE: Processing ScriptProperty : SumGB
VERBOSE: Creating scriptblock from value
VERBOSE: Performing the operation "Adding ScriptProperty SumGB" on target "Microsoft.PowerShell.Commands.GenericMeasureInfo".
VERBOSE: Ending: Import-PSTypeExtension

PS C:\> dir D:\VMDisks\ -file -Recurse | measure length -sum | select Count,SumGB

Count   SumGB
-----   -----
    4 50.2031
```

This project was first described at <http://jdhitsolutions.com/blog/powershell/5777/a-powershell-module-for-your-type-extensions>

There is also an about topic you can read:

```powershell
help about_PSTypeExtensionTools
```

Last Updated 2021-03-08 21:19:40Z
