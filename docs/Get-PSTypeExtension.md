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
Get-PSTypeExtension [-TypeName] <String> [-Members <String[]>] [<CommonParameters>]
```

## DESCRIPTION

Use this command to list defined type extensions. You can either select individual ones or all of them. Do not specify any members to retrieve all of them. This command is very similar to Get-TypeData, except that it makes it easier to see the extension value.

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
PS C:\> get-process | get-pstype | Get-PSTypeExtension


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

Enter the name of type like System.IO.FileInfo.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-TypeData]()
