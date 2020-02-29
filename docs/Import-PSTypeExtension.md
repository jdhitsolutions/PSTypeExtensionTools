---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: http://bit.ly/30GCsUp
schema: 2.0.0
---

# Import-PSTypeExtension

## SYNOPSIS

Import type extension definitions.

## SYNTAX

```yaml
Import-PSTypeExtension [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to import extended type definitions from a json or xml file that was created with Export-PSTypeExtension.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Import-PSTypeExtension -Path C:\work\stringtypes.json
```

Import definitions from a json file.

### EXAMPLE 2

```powershell
PS C:\> dir c:\scripts\mytypes | Import-PSTypeExtension
```

Import definitions from files in C:\Scripts\MyTypes. Presumably, these are xml or json files created with Export-PSTypeExtension.

## PARAMETERS

### -Path

The name of the imported file. The extension must be .xml or .json.

```yaml
Type: String
Parameter Sets: (All)
Aliases: fullname

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-PSTypeExtension]()

[Update-TypeData]()

[Get-PSTypeExtension]()
