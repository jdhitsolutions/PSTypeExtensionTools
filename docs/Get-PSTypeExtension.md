---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: http://bit.ly/30FkW2t
schema: 2.0.0
---

# Get-PSTypeExtension

## SYNOPSIS

Get selected type extensions.

## SYNTAX

```yaml
Get-PSTypeExtension [-TypeName] <String> [-Members <String[]>] [-CodeProperty] [-Force] [<CommonParameters>]
```

## DESCRIPTION

Use this command to list defined type extensions. You can either select individual ones or all of them. Do not specify any members to retrieve all of them. This command is very similar to Get-TypeData, except that it makes it easier to see the extension value. If you are specifying a custom type name, you may need to use -Force for the command to accept it as written.

By default, CodeProperty members are not displayed because they can't be exported.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Get-PSTypeExtension system.string

   TypeName: System.String

Name        Type           Value
----        ----           -----
Size        AliasProperty  Length
IsIPAddress ScriptMethod   $this -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
Reverse     ScriptMethod   for ($i=$this.length;$i -ge 0;$i--) {...
IsEmail     ScriptProperty  $this -match '^\S+@([\w-]+)\.(com|edu|org|net)$'
Randomize   ScriptMethod   ($this.ToCharArray() | get-random -Count $this.length) -join ""
```

Get all type extensions for System.String.

### EXAMPLE 2

```powershell
PS C:\> Get-PSTypeExtension system.string -members size

   TypeName: System.String

Name Type          Value
---- ----          -----
Size AliasProperty Length
```

Get the Size type extension for System.String.

### EXAMPLE 3

```powershell
PS C:\> Get-Process | Get-PSType | Get-PSTypeExtension


   TypeName: System.Diagnostics.Process

Name           Type           Value
----           ----           -----
Name           AliasProperty  ProcessName
SI             AliasProperty  SessionId
Handles        AliasProperty  Handlecount
VM             AliasProperty  VirtualMemorySize64
WS             AliasProperty  WorkingSet64
PM             AliasProperty  PagedMemorySize64
NPM            AliasProperty  NonpagedSystemMemorySize64
Path           ScriptProperty $this.Mainmodule.FileName
Company        ScriptProperty $this.Mainmodule.FileVersionInfo.CompanyName
CPU            ScriptProperty $this.TotalProcessorTime.TotalSeconds
FileVersion    ScriptProperty $this.Mainmodule.FileVersionInfo.FileVersion
ProductVersion ScriptProperty $this.Mainmodule.FileVersionInfo.ProductVersion
Description    ScriptProperty $this.Mainmodule.FileVersionInfo.FileDescription
Product        ScriptProperty $this.Mainmodule.FileVersionInfo.ProductName
__NounName     Noteproperty   Process
```

Discover type extensions for a given type of object.

### Example 4

```powershell
PS C:\>  Get-PSTypeExtension system.io.fileinfo  -CodeProperty |
Select-Object membername,membertype

MemberName          MemberType
----------          ----------
Size                AliasProperty
Modified            AliasProperty
Created             AliasProperty
Mode                CodeProperty
ModeWithoutHardLink CodeProperty
Target              CodeProperty
LinkType            CodeProperty
NameString          CodeProperty
LengthString        CodeProperty
LastWriteTimeString CodeProperty
VersionInfo         ScriptProperty
BaseName            ScriptProperty
SizeKB              ScriptProperty
SizeMB              ScriptProperty
```

Display all extensions, including CodeProperty, and display the member name and type.

## PARAMETERS

### -Members

Enter a comma-separated list of member names.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName

Enter the name of a type like System.IO.FileInfo.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -CodeProperty

Show CodeProperty custom properties

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Force the command to accept the name as a type.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSTypeExtension

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSType](Get-PSType.md)

[Export-PSTypeExtension](Export-PSTypeExtension.md)

[Get-TypeData]()
