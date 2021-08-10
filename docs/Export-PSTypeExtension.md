---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: http://bit.ly/30FkCRj
schema: 2.0.0
---

# Export-PSTypeExtension

## SYNOPSIS

Export type extensions to a file.

## SYNTAX

### Object (Default)

```yaml
Export-PSTypeExtension -Path <String> [-InputObject <Object>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name

```yaml
Export-PSTypeExtension [-TypeName] <String> -MemberName <String[]>
-Path <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

You can use this command in two ways. First, you can export custom type information to a JSON or XML file to import in another PowerShell session using Import-PSTypeExtension. Or you can export the type extensions to a properly formatted ps1xml file, which you can import using Update-TypeData. Export-PSTypeExtension will create the appropriate file based on the extension in the specified path.

If you are exporting to a .ps1xml file, you can use a dynamic parameter called Append. You might want to do this if you have created a property set using New-PSPropertySet, and want to include additional type extensions in the same file.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Export-PSTypeExtension -TypeName system.string -Path c:\work\mystringtypes.json -MemberName Size,IsIPAddress
```

Export selected type extensions for System.String to a JSON file.

### EXAMPLE 2

```powershell
PS C:\> Get-PSTypeExtension system.string | Export-PSTypeExtension -path c:\work\stringtypes.xml
```

Get all type extensions for System.String and export to an XML file.

### EXAMPLE 3

```powershell
PS C:\> Get-PSTypeExtension system.string -members "IsIpAddress","Size","Randomize" | Export-PSTypeExtension -path c:\work\mystring.type.ps1xml -passthru

    Directory: C:\work


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          3/9/2021  11:15 AM            858 mystring.type.ps1xml
```

Export the selected members to a ps1xml file and pass the file object to the pipeline.

### EXAMPLE 4

```powershell
PS C:\work> Get-PSTypeExtension system.string |
Export-PSTypeExtension -Path .\all.ps1xml
PS C:\work> Get-PSTypeExtension system.io.fileinfo |
Export-PSTypeExtension -Path .\all.ps1xml -append
PS C:\work>  Get-PSTypeExtension system.serviceprocess.servicecontroller -Members State | Export-PSTypeExtension -Path .\all.ps1xml -append
```

Export multiple type extensions to the same .ps1xml file. You can use Update-TypeData to load this file in another PowerShell session. Although, you might see errors if there is an existing type extension with the same name.

## PARAMETERS

### -MemberName

The type extension name.

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The name of the exported file. The extension must be .xml, .ps1xml or .json.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName

The type name to export like System.IO.FileInfo.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject

This is typically the output of Get-PSSTypeExtension.

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Passthru

Display the new file object.

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

### System.Object

## OUTPUTS

### None

### Sytstem.IO.File

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Import-PSTypeExtension](Import-PSTypeExtension.md)

[Get-PSTypeExtension](Get-PSTypeExtension.md)
