# PSTypeExtensionTools

This PowerShell module contains commands that make it easier to work with type extensions. Many of these commands are wrappers for built-in tools like [Get-TypeData](http://go.microsoft.com/fwlink/?LinkId=821805) or [Update-TypeData](http://go.microsoft.com/fwlink/?LinkId=821871).

## Release
The current release is [v1.0.0](https://github.com/jdhitsolutions/PSTypeExtensionTools/releases/tag/v1.0.0).

You can also install from the PowerShell Gallery:

```
Install-Module PSTypeExtensionTools
```
## Why you want to use this
Let's say you want to update a number object, but you have no idea what the type name is. Once you have read help for the commands in this module you could run a PowerShell command like this:
```
PS C:\> 123 | Get-PSType | 
Add-PSTypeExtension -MemberType ScriptProperty -MemberName SquareRoot -Value { [math]::Sqrt($this)}
```
Use `$this` to reference the object instead of `$_`.  Now you can get the new property.

```
PS C:\> $x = 123
PS C:\> $x.SquareRoot
11.0905365064094
```
Once you know the type name you can add other type extensions.
```
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Squared -value { $this*$this}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Cubed -value { [math]::Pow($this,3)}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptProperty -MemberName Value -value { $this}
PS C:\> Add-PSTypeExtension -TypeName system.int32 -MemberType ScriptMethod -MemberName GetPercent -value {Param([int32]$Total,[int32]$Round=2) [math]::Round(($this/$total)*100,$round)}

```
Here's how it might look:
```
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
To see what has been defined you can use `Get-PSTypeExtension`. You can choose to see all extensions or selected ones by member name.
```
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
If you always want these extensions you would have to put the commands into your PowerShell profile script. Or you can export the extensions to a json or xml file. You can either export all members or selected ones which is helpful if you are extending a type that already has type extensions from PowerShell.
```
PS C:\> Get-PSTypeExtension system.int32  | 
Export-PSTypeExtension -TypeName system.int32 -Path c:\work\int32-types.json
```
In your PowerShell profile script you can then re-import the type extension definitions.
```
Import-PSTypeExtension -Path C:\work\int32-types.json
```
## Create ps1xml files
The export command makes it easy to construct a ps1xml file. All you need to do is provide the type name and the extensions you want to export, and it will create a properly formatted ps1xml file that you can import  into a session with `Update-TypeData` or distribute with a module. No more clunky XML copying, pasting and hoping for the best.

## I want to try
You can find a number of type extension exports in the [Samples](./samples) folder.

## PSTypeExtensionTools Cmdlets
### [Add-PSTypeExtension](./docs/Add-PSTypeExtension.md)
Add a new type extension such as an Alias or ScriptProperty.

### [Export-PSTypeExtension](./docs/Export-PSTypeExtension.md)
Export type extensions to a json, xml or ps1xml file.

### [Get-PSType](./docs/Get-PSType.md)
Get the type name of an object.

### [Get-PSTypeExtension](./docs/Get-PSTypeExtension.md)
Get type extensions for a given type.

### [Import-PSTypeExtension](./docs/Import-PSTypeExtension.md)
Import type extension definitions from a json file or xml.

This project was first described at http://jdhitsolutions.com/blog/powershell/5777/a-powershell-module-for-your-type-extensions

There is also an about topic you can read:

```
help about_pstypeextensiontools
```

*last updated 15 December 2017*
