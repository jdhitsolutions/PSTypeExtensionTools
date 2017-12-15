---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Export-PSTypeExtension

## SYNOPSIS
Export type extensions to a file.

## SYNTAX

### Object (Default)
```
Export-PSTypeExtension -Path <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Export-PSTypeExtension [-TypeName] <String> -MemberName <String[]> -Path <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### object
```
Export-PSTypeExtension -Path <String> [-InputObject <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This command can be used in 2 ways. First, you can export custom type information to a json or xml file to make it easier to recreate them in another PowerShell session. Or you can export the type extensions to a properly formatted ps1xml file which you can use with Update-TypeData. The command will create the appropriate file based on the extension in the specified path.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Export-PSTypeExtension -TypeName system.string -Path c:\work\mystringtypes.json -MemberName Size,IsIPAddress
```

Export selected type extensions for System.String to a json file.

### EXAMPLE 2
```
PS C:\> Get-PSTypeExtension system.string | Export-PSTypeExtension -path c:\work\stringtypes.xml
```

Get all type extensions for System.String and export to an xml file.

### EXAMPLE 3
```
PS C:\> Get-PSTypeExtension system.string -members "IsIpAddress","Size","Randomize" | Export-PSTypeExtension -path c:\work\mystring.type.ps1xml
```

Export the selected members to a properly formatted ps1xml file.
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
Parameter Sets: object
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### None

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Import-PSTypeExtension]()

[Get-PSTypeExtension]()
