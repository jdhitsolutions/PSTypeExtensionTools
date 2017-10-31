---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Import-MyTypeExtension

## SYNOPSIS
Import type extension data from a JSON file.

## SYNTAX

```
Import-MyTypeExtension [-Path] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Use this command to import type extension setting data from a json file presumably created with Export-MyTypeExtension. The settings will be created in the current PowerShell session, overwriting any existing entries with the same name.

## EXAMPLES

### Example 1
```
PS C:\> Import-MyTypeExtension c:\scripts\measure-types.json
```

Import type extensions from the json file.

### Example 2
```
PS C:\> Import-MyTypeExtension -Path S:\fileinfo-types.json -whatif
What if: Performing the operation "Adding AliasProperty Size" on target "System.IO.FileInfo".
What if: Performing the operation "Adding AliasProperty Modified" on target "System.IO.FileInfo".
What if: Performing the operation "Adding AliasProperty Created" on target "System.IO.FileInfo".
What if: Performing the operation "Adding ScriptProperty SizeKB" on target "System.IO.FileInfo".
```
Testing the impact of importing type extensions.
## PARAMETERS

### -Path
The path to a json file with type extension information.

```yaml
Type: String
Parameter Sets: (All)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-MyTypeExtension]()
